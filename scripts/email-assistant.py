#!/usr/bin/env python3
"""
Email Assistant - AI-powered email categorization and management
Supports multiple AI models (Ollama, Anthropic, OpenAI) and email providers (Office 365, IMAP)
"""

import argparse
import json
import logging
import os
import sys
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Any, Dict, List, Optional

# Third-party imports (will be in requirements.txt)
try:
    import anthropic
    import openai
    import requests
    import yaml
    from msal import ConfidentialClientApplication, PublicClientApplication
except ImportError as e:
    print(f"Missing required package: {e.name}")
    print("Run: pip install -r requirements.txt")
    sys.exit(1)


# Setup logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class EmailAction(Enum):
    """Actions to take on emails"""

    KEEP_INBOX = "keep_inbox"
    ARCHIVE = "archive"
    DELETE = "delete"
    MARK_READ = "mark_read"
    MARK_UNREAD = "mark_unread"
    FLAG = "flag"
    MOVE_FOLDER = "move_folder"


@dataclass
class Email:
    """Email data structure"""

    id: str
    subject: str
    sender: str
    sender_email: str
    body_preview: str
    received_datetime: str
    is_read: bool
    folder: Optional[str] = None

    def to_summary(self) -> str:
        """Create a summary for AI analysis"""
        return f"""
Subject: {self.subject}
From: {self.sender} <{self.sender_email}>
Date: {self.received_datetime}
Preview: {self.body_preview}
""".strip()


@dataclass
class EmailCategory:
    """Categorization result"""

    action: EmailAction
    reason: str
    folder: Optional[str] = None
    confidence: Optional[float] = None


# ============================================================================
# MODEL ABSTRACTION LAYER
# ============================================================================


class AIModel(ABC):
    """Abstract base class for AI models"""

    @abstractmethod
    def categorize_email(self, email: Email, prompt: str) -> EmailCategory:
        """Categorize an email based on the prompt"""
        pass

    @abstractmethod
    def test_connection(self) -> bool:
        """Test if the model is accessible"""
        pass


class OllamaModel(AIModel):
    """Ollama local model implementation"""

    def __init__(
        self, base_url: str = "http://localhost:11434", model: str = "qwen2.5:7b"
    ):
        self.base_url = base_url.rstrip("/")
        self.model = model

    def test_connection(self) -> bool:
        try:
            response = requests.get(f"{self.base_url}/api/tags", timeout=5)
            return response.status_code == 200
        except Exception as e:
            logger.error(f"Ollama connection failed: {e}")
            return False

    def categorize_email(self, email: Email, prompt: str) -> EmailCategory:
        """Categorize email using Ollama"""
        full_prompt = f"""{prompt}

Email to categorize:
{email.to_summary()}

Respond in JSON format:
{{
    "action": "keep_inbox|archive|delete|mark_read|move_folder",
    "reason": "brief explanation",
    "folder": "folder name if action is move_folder, otherwise null"
}}
"""

        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": self.model,
                    "prompt": full_prompt,
                    "stream": False,
                    "format": "json",
                },
                timeout=30,
            )
            response.raise_for_status()

            result = response.json()
            ai_response = json.loads(result["response"])

            return EmailCategory(
                action=EmailAction(ai_response["action"]),
                reason=ai_response["reason"],
                folder=ai_response.get("folder"),
            )
        except Exception as e:
            logger.error(f"Ollama categorization failed: {e}")
            # Default to keeping in inbox on error
            return EmailCategory(
                action=EmailAction.KEEP_INBOX,
                reason=f"Error during categorization: {str(e)}",
            )


class AnthropicModel(AIModel):
    """Anthropic Claude API implementation"""

    def __init__(self, api_key: str, model: str = "claude-3-5-sonnet-20241022"):
        self.client = anthropic.Anthropic(api_key=api_key)
        self.model = model

    def test_connection(self) -> bool:
        try:
            # Simple test message
            self.client.messages.create(
                model=self.model,
                max_tokens=10,
                messages=[{"role": "user", "content": "test"}],
            )
            return True
        except Exception as e:
            logger.error(f"Anthropic connection failed: {e}")
            return False

    def categorize_email(self, email: Email, prompt: str) -> EmailCategory:
        """Categorize email using Claude"""
        full_prompt = f"""{prompt}

Email to categorize:
{email.to_summary()}

Respond in JSON format:
{{
    "action": "keep_inbox|archive|delete|mark_read|move_folder",
    "reason": "brief explanation",
    "folder": "folder name if action is move_folder, otherwise null"
}}
"""

        try:
            message = self.client.messages.create(
                model=self.model,
                max_tokens=1024,
                messages=[{"role": "user", "content": full_prompt}],
            )

            ai_response = json.loads(message.content[0].text)

            return EmailCategory(
                action=EmailAction(ai_response["action"]),
                reason=ai_response["reason"],
                folder=ai_response.get("folder"),
            )
        except Exception as e:
            logger.error(f"Anthropic categorization failed: {e}")
            return EmailCategory(
                action=EmailAction.KEEP_INBOX,
                reason=f"Error during categorization: {str(e)}",
            )


class OpenAIModel(AIModel):
    """OpenAI GPT implementation"""

    def __init__(self, api_key: str, model: str = "gpt-4"):
        self.client = openai.OpenAI(api_key=api_key)
        self.model = model

    def test_connection(self) -> bool:
        try:
            self.client.chat.completions.create(
                model=self.model,
                messages=[{"role": "user", "content": "test"}],
                max_tokens=10,
            )
            return True
        except Exception as e:
            logger.error(f"OpenAI connection failed: {e}")
            return False

    def categorize_email(self, email: Email, prompt: str) -> EmailCategory:
        """Categorize email using GPT"""
        full_prompt = f"""{prompt}

Email to categorize:
{email.to_summary()}

Respond in JSON format:
{{
    "action": "keep_inbox|archive|delete|mark_read|move_folder",
    "reason": "brief explanation",
    "folder": "folder name if action is move_folder, otherwise null"
}}
"""

        try:
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[{"role": "user", "content": full_prompt}],
                response_format={"type": "json_object"},
                max_tokens=1024,
            )

            ai_response = json.loads(response.choices[0].message.content)

            return EmailCategory(
                action=EmailAction(ai_response["action"]),
                reason=ai_response["reason"],
                folder=ai_response.get("folder"),
            )
        except Exception as e:
            logger.error(f"OpenAI categorization failed: {e}")
            return EmailCategory(
                action=EmailAction.KEEP_INBOX,
                reason=f"Error during categorization: {str(e)}",
            )


# ============================================================================
# EMAIL PROVIDER ABSTRACTION LAYER
# ============================================================================


class EmailProvider(ABC):
    """Abstract base class for email providers"""

    @abstractmethod
    def get_emails(self, folder: str = "inbox", limit: int = 50) -> List[Email]:
        """Get emails from a folder"""
        pass

    @abstractmethod
    def move_email(self, email_id: str, destination_folder: str) -> bool:
        """Move email to a folder"""
        pass

    @abstractmethod
    def mark_as_read(self, email_id: str) -> bool:
        """Mark email as read"""
        pass

    @abstractmethod
    def delete_email(self, email_id: str) -> bool:
        """Delete an email"""
        pass

    @abstractmethod
    def test_connection(self) -> bool:
        """Test if provider is accessible"""
        pass


class Office365Provider(EmailProvider):
    """Microsoft Office 365 / Outlook email provider"""

    def __init__(
        self,
        client_id: str,
        client_secret: Optional[str] = None,
        tenant_id: str = "common",
        user_email: Optional[str] = None,
    ):
        self.client_id = client_id
        self.client_secret = client_secret
        self.tenant_id = tenant_id
        self.user_email = user_email
        self.access_token = None
        self._authenticate()

    def _authenticate(self):
        """Authenticate with Microsoft Graph API"""
        authority = f"https://login.microsoftonline.com/{self.tenant_id}"
        scopes = ["https://graph.microsoft.com/.default"]

        if self.client_secret:
            # Service principal authentication
            app = ConfidentialClientApplication(
                self.client_id,
                authority=authority,
                client_credential=self.client_secret,
            )
            result = app.acquire_token_for_client(scopes=scopes)
        else:
            # Device code flow for interactive auth
            app = PublicClientApplication(self.client_id, authority=authority)
            scopes = ["Mail.ReadWrite", "Mail.Send"]

            # Try to get token from cache first
            accounts = app.get_accounts()
            if accounts:
                result = app.acquire_token_silent(scopes, account=accounts[0])
            else:
                flow = app.initiate_device_flow(scopes=scopes)
                print(flow["message"])
                result = app.acquire_token_by_device_flow(flow)

        if "access_token" in result:
            self.access_token = result["access_token"]
            logger.info("Successfully authenticated with Office 365")
        else:
            raise Exception(f"Authentication failed: {result.get('error_description')}")

    def _make_request(self, method: str, endpoint: str, **kwargs) -> requests.Response:
        """Make authenticated request to Graph API"""
        url = f"https://graph.microsoft.com/v1.0{endpoint}"
        headers = {
            "Authorization": f"Bearer {self.access_token}",
            "Content-Type": "application/json",
        }
        response = requests.request(method, url, headers=headers, **kwargs)
        response.raise_for_status()
        return response

    def test_connection(self) -> bool:
        try:
            self._make_request("GET", "/me/mailFolders")
            return True
        except Exception as e:
            logger.error(f"Office 365 connection test failed: {e}")
            return False

    def get_emails(self, folder: str = "inbox", limit: int = 50) -> List[Email]:
        """Get emails from Office 365"""
        try:
            response = self._make_request(
                "GET",
                f"/me/mailFolders/{folder}/messages",
                params={
                    "$top": limit,
                    "$select": "id,subject,from,bodyPreview,receivedDateTime,isRead",
                    "$orderby": "receivedDateTime DESC",
                },
            )

            data = response.json()
            emails = []

            for item in data.get("value", []):
                emails.append(
                    Email(
                        id=item["id"],
                        subject=item.get("subject", "(no subject)"),
                        sender=item["from"]["emailAddress"]["name"],
                        sender_email=item["from"]["emailAddress"]["address"],
                        body_preview=item.get("bodyPreview", ""),
                        received_datetime=item["receivedDateTime"],
                        is_read=item.get("isRead", False),
                        folder=folder,
                    )
                )

            return emails
        except Exception as e:
            logger.error(f"Failed to get emails: {e}")
            return []

    def move_email(self, email_id: str, destination_folder: str) -> bool:
        """Move email to folder"""
        try:
            self._make_request(
                "POST",
                f"/me/messages/{email_id}/move",
                json={"destinationId": destination_folder},
            )
            return True
        except Exception as e:
            logger.error(f"Failed to move email: {e}")
            return False

    def mark_as_read(self, email_id: str) -> bool:
        """Mark email as read"""
        try:
            self._make_request(
                "PATCH", f"/me/messages/{email_id}", json={"isRead": True}
            )
            return True
        except Exception as e:
            logger.error(f"Failed to mark as read: {e}")
            return False

    def delete_email(self, email_id: str) -> bool:
        """Delete email"""
        try:
            self._make_request("DELETE", f"/me/messages/{email_id}")
            return True
        except Exception as e:
            logger.error(f"Failed to delete email: {e}")
            return False


class IMAPProvider(EmailProvider):
    """Generic IMAP email provider (Gmail, Proton, etc.)"""

    def __init__(
        self, host: str, port: int, username: str, password: str, use_ssl: bool = True
    ):
        import email
        import imaplib
        from email.header import decode_header

        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.use_ssl = use_ssl
        self.imap = None
        self.email_module = email
        self.decode_header = decode_header
        self._connect()

    def _connect(self):
        """Connect to IMAP server"""
        import imaplib

        try:
            if self.use_ssl:
                self.imap = imaplib.IMAP4_SSL(self.host, self.port)
            else:
                self.imap = imaplib.IMAP4(self.host, self.port)

            self.imap.login(self.username, self.password)
            logger.info(f"Successfully connected to IMAP server {self.host}")
        except Exception as e:
            raise Exception(f"IMAP connection failed: {e}")

    def test_connection(self) -> bool:
        try:
            status, _ = self.imap.list()
            return status == "OK"
        except Exception as e:
            logger.error(f"IMAP connection test failed: {e}")
            return False

    def get_emails(self, folder: str = "INBOX", limit: int = 50) -> List[Email]:
        """Get emails from IMAP"""
        try:
            self.imap.select(folder)
            _, message_numbers = self.imap.search(None, "ALL")

            # Get most recent emails
            msg_ids = message_numbers[0].split()[-limit:]
            emails = []

            for msg_id in msg_ids:
                _, msg_data = self.imap.fetch(msg_id, "(RFC822)")
                email_body = msg_data[0][1]
                email_message = self.email_module.message_from_bytes(email_body)

                # Decode subject
                subject = email_message["subject"]
                if subject:
                    decoded = self.decode_header(subject)[0]
                    if isinstance(decoded[0], bytes):
                        subject = decoded[0].decode(decoded[1] or "utf-8")
                    else:
                        subject = decoded[0]
                else:
                    subject = "(no subject)"

                # Get body preview
                body_preview = ""
                if email_message.is_multipart():
                    for part in email_message.walk():
                        if part.get_content_type() == "text/plain":
                            body_preview = part.get_payload(decode=True).decode(
                                "utf-8", errors="ignore"
                            )[:200]
                            break
                else:
                    body_preview = email_message.get_payload(decode=True).decode(
                        "utf-8", errors="ignore"
                    )[:200]

                emails.append(
                    Email(
                        id=msg_id.decode(),
                        subject=subject,
                        sender=email_message.get("From", "Unknown"),
                        sender_email=email_message.get("From", "Unknown"),
                        body_preview=body_preview,
                        received_datetime=email_message.get("Date", ""),
                        is_read=False,  # IMAP doesn't easily expose this
                        folder=folder,
                    )
                )

            return emails
        except Exception as e:
            logger.error(f"Failed to get emails: {e}")
            return []

    def move_email(self, email_id: str, destination_folder: str) -> bool:
        """Move email to folder"""
        try:
            self.imap.copy(email_id, destination_folder)
            self.imap.store(email_id, "+FLAGS", "\\Deleted")
            self.imap.expunge()
            return True
        except Exception as e:
            logger.error(f"Failed to move email: {e}")
            return False

    def mark_as_read(self, email_id: str) -> bool:
        """Mark email as read"""
        try:
            self.imap.store(email_id, "+FLAGS", "\\Seen")
            return True
        except Exception as e:
            logger.error(f"Failed to mark as read: {e}")
            return False

    def delete_email(self, email_id: str) -> bool:
        """Delete email"""
        try:
            self.imap.store(email_id, "+FLAGS", "\\Deleted")
            self.imap.expunge()
            return True
        except Exception as e:
            logger.error(f"Failed to delete email: {e}")
            return False


# ============================================================================
# CONFIGURATION MANAGEMENT
# ============================================================================


class Config:
    """Configuration management with support for files, env vars, and Docker secrets"""

    def __init__(self, config_file: Optional[Path] = None):
        self.config = {}

        # Load from config file if provided
        if config_file and config_file.exists():
            with open(config_file, "r") as f:
                self.config = yaml.safe_load(f) or {}
            logger.info(f"Loaded config from {config_file}")

        # Override with environment variables
        self._load_env_vars()

        # Try to load Docker secrets
        self._load_docker_secrets()

    def _load_env_vars(self):
        """Load configuration from environment variables"""
        env_mapping = {
            "EMAIL_PROVIDER": "email.provider",
            "EMAIL_HOST": "email.imap.host",
            "EMAIL_PORT": "email.imap.port",
            "EMAIL_USERNAME": "email.username",
            "EMAIL_PASSWORD": "email.password",
            "O365_CLIENT_ID": "email.office365.client_id",
            "O365_CLIENT_SECRET": "email.office365.client_secret",
            "O365_TENANT_ID": "email.office365.tenant_id",
            "AI_MODEL": "ai.model",
            "OLLAMA_URL": "ai.ollama.url",
            "OLLAMA_MODEL": "ai.ollama.model",
            "ANTHROPIC_API_KEY": "ai.anthropic.api_key",
            "OPENAI_API_KEY": "ai.openai.api_key",
        }

        for env_key, config_key in env_mapping.items():
            value = os.getenv(env_key)
            if value:
                self._set_nested(config_key, value)

    def _load_docker_secrets(self):
        """Load secrets from Docker Swarm secrets directory"""
        secrets_dir = Path("/run/secrets")
        if not secrets_dir.exists():
            return

        secret_mapping = {
            "email_password": "email.password",
            "o365_client_secret": "email.office365.client_secret",
            "anthropic_api_key": "ai.anthropic.api_key",
            "openai_api_key": "ai.openai.api_key",
        }

        for secret_file, config_key in secret_mapping.items():
            secret_path = secrets_dir / secret_file
            if secret_path.exists():
                with open(secret_path, "r") as f:
                    value = f.read().strip()
                    self._set_nested(config_key, value)
                logger.info(f"Loaded secret: {secret_file}")

    def _set_nested(self, key: str, value: Any):
        """Set nested dictionary value using dot notation"""
        keys = key.split(".")
        d = self.config
        for k in keys[:-1]:
            d = d.setdefault(k, {})
        d[keys[-1]] = value

    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value using dot notation"""
        keys = key.split(".")
        value = self.config
        for k in keys:
            if isinstance(value, dict):
                value = value.get(k)
            else:
                return default
        return value if value is not None else default


# ============================================================================
# MAIN APPLICATION
# ============================================================================


class EmailAssistant:
    """Main email assistant application"""

    def __init__(self, config: Config, dry_run: bool = True):
        self.config = config
        self.dry_run = dry_run
        self.ai_model = self._init_ai_model()
        self.email_provider = self._init_email_provider()

    def _init_ai_model(self) -> AIModel:
        """Initialize AI model based on config"""
        model_type = self.config.get("ai.model", "ollama")

        if model_type == "ollama":
            url = self.config.get("ai.ollama.url", "http://localhost:11434")
            model = self.config.get("ai.ollama.model", "qwen2.5:7b")
            return OllamaModel(base_url=url, model=model)

        elif model_type == "anthropic":
            api_key = self.config.get("ai.anthropic.api_key")
            if not api_key:
                raise ValueError("Anthropic API key not found in config")
            model = self.config.get("ai.anthropic.model", "claude-3-5-sonnet-20241022")
            return AnthropicModel(api_key=api_key, model=model)

        elif model_type == "openai":
            api_key = self.config.get("ai.openai.api_key")
            if not api_key:
                raise ValueError("OpenAI API key not found in config")
            model = self.config.get("ai.openai.model", "gpt-4")
            return OpenAIModel(api_key=api_key, model=model)

        else:
            raise ValueError(f"Unknown AI model type: {model_type}")

    def _init_email_provider(self) -> EmailProvider:
        """Initialize email provider based on config"""
        provider_type = self.config.get("email.provider", "office365")

        if provider_type == "office365":
            return Office365Provider(
                client_id=self.config.get("email.office365.client_id"),
                client_secret=self.config.get("email.office365.client_secret"),
                tenant_id=self.config.get("email.office365.tenant_id", "common"),
                user_email=self.config.get("email.username"),
            )

        elif provider_type in ["imap", "gmail", "proton"]:
            return IMAPProvider(
                host=self.config.get("email.imap.host"),
                port=int(self.config.get("email.imap.port", 993)),
                username=self.config.get("email.username"),
                password=self.config.get("email.password"),
                use_ssl=self.config.get("email.imap.ssl", True),
            )

        else:
            raise ValueError(f"Unknown email provider: {provider_type}")

    def test_connections(self) -> bool:
        """Test all connections"""
        logger.info("Testing AI model connection...")
        if not self.ai_model.test_connection():
            logger.error("AI model connection failed")
            return False
        logger.info("✓ AI model connection successful")

        logger.info("Testing email provider connection...")
        if not self.email_provider.test_connection():
            logger.error("Email provider connection failed")
            return False
        logger.info("✓ Email provider connection successful")

        return True

    def process_emails(self, folder: str = "inbox", limit: int = 50):
        """Process emails from inbox"""
        # Load categorization prompt
        prompt = self.config.get("categorization.prompt", self._default_prompt())

        logger.info(f"Fetching up to {limit} emails from {folder}...")
        emails = self.email_provider.get_emails(folder=folder, limit=limit)
        logger.info(f"Found {len(emails)} emails")

        results = []
        for i, email in enumerate(emails, 1):
            logger.info(f"\n[{i}/{len(emails)}] Processing: {email.subject}")
            logger.info(f"  From: {email.sender_email}")

            category = self.ai_model.categorize_email(email, prompt)

            logger.info(f"  Decision: {category.action.value}")
            logger.info(f"  Reason: {category.reason}")

            if not self.dry_run:
                success = self._apply_action(email, category)
                if success:
                    logger.info(f"  ✓ Action applied")
                else:
                    logger.error(f"  ✗ Action failed")
            else:
                logger.info(f"  [DRY RUN] Would apply action: {category.action.value}")

            results.append({"email": email, "category": category})

        return results

    def _apply_action(self, email: Email, category: EmailCategory) -> bool:
        """Apply categorization action to email"""
        action = category.action

        if action == EmailAction.KEEP_INBOX:
            return True
        elif action == EmailAction.ARCHIVE:
            return self.email_provider.move_email(email.id, "archive")
        elif action == EmailAction.DELETE:
            return self.email_provider.delete_email(email.id)
        elif action == EmailAction.MARK_READ:
            return self.email_provider.mark_as_read(email.id)
        elif action == EmailAction.MOVE_FOLDER:
            if category.folder:
                return self.email_provider.move_email(email.id, category.folder)
            return False
        else:
            logger.warning(f"Unknown action: {action}")
            return False

    def _default_prompt(self) -> str:
        """Default categorization prompt"""
        return """You are an email categorization assistant. Analyze the following email and decide what action to take.

Categories:
- keep_inbox: Important emails that need attention
- archive: Newsletters, receipts, confirmations that are done with
- mark_read: Low priority items to mark as read but keep
- move_folder: Emails that belong in specific folders
- delete: Spam or completely irrelevant emails

Keep anything that seems important, work-related, or requires action.
Archive newsletters, marketing emails, and transactional emails (receipts, confirmations).
Only delete obvious spam."""


def main():
    parser = argparse.ArgumentParser(
        description="AI-powered email categorization and management",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Dry run (default) - just show what would happen
  %(prog)s --config config.yaml

  # Actually apply changes
  %(prog)s --config config.yaml --execute

  # Process specific folder
  %(prog)s --folder spam --limit 100

  # Test connections only
  %(prog)s --config config.yaml --test

  # Use environment variables (no config file needed)
  EMAIL_PROVIDER=office365 O365_CLIENT_ID=xxx %(prog)s
        """,
    )

    parser.add_argument("--config", "-c", type=Path, help="Configuration file (YAML)")
    parser.add_argument(
        "--execute",
        action="store_true",
        help="Actually apply actions (default is dry-run)",
    )
    parser.add_argument(
        "--folder", default="inbox", help="Email folder to process (default: inbox)"
    )
    parser.add_argument(
        "--limit",
        "-n",
        type=int,
        default=50,
        help="Maximum number of emails to process (default: 50)",
    )
    parser.add_argument("--test", action="store_true", help="Test connections and exit")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")

    args = parser.parse_args()

    if args.verbose:
        logger.setLevel(logging.DEBUG)

    # Load configuration
    config = Config(args.config)

    # Initialize assistant
    dry_run = not args.execute
    if dry_run:
        logger.info("=" * 60)
        logger.info("DRY RUN MODE - No changes will be made")
        logger.info("Use --execute to actually apply actions")
        logger.info("=" * 60)

    assistant = EmailAssistant(config, dry_run=dry_run)

    # Test connections
    if not assistant.test_connections():
        logger.error("Connection tests failed")
        sys.exit(1)

    if args.test:
        logger.info("Connection tests passed!")
        sys.exit(0)

    # Process emails
    results = assistant.process_emails(folder=args.folder, limit=args.limit)

    # Summary
    logger.info("\n" + "=" * 60)
    logger.info("SUMMARY")
    logger.info("=" * 60)
    logger.info(f"Total emails processed: {len(results)}")

    action_counts = {}
    for result in results:
        action = result["category"].action.value
        action_counts[action] = action_counts.get(action, 0) + 1

    for action, count in action_counts.items():
        logger.info(f"  {action}: {count}")

    if dry_run:
        logger.info("\n[DRY RUN] No changes were made. Use --execute to apply actions.")


if __name__ == "__main__":
    main()

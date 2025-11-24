.PHONY: depends
.SILENT: depends

depends:
	echo "Checking if running on Arch Linux..."
	if ! grep -q "ID=arch" /etc/os-release; then \
		echo "Error: This system is not Arch Linux"; \
		exit 1; \
	fi
	echo "Installing reflector..."
	sudo pacman -S --needed --noconfirm --quiet reflector && \
	if [ -f /etc/pacman.d/mirrorlist ]; then \
		echo "Mirrorlist last updated: $$(stat -c '%y' /etc/pacman.d/mirrorlist)"; \
		if [ $$(find /etc/pacman.d/mirrorlist -mtime -7 2>/dev/null | wc -l) -gt 0 ]; then \
			echo "Mirrorlist was updated within the last 7 days, skipping reflector..."; \
		else \
			echo "Running reflector to update mirrorlist..."; \
			sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist; \
		fi \
	else \
		echo "Running reflector to create mirrorlist..."; \
		sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist; \
	fi && \
	echo "Updating and installing remaining dependencies..." && \
	sudo pacman -Syyu --needed --noconfirm --quiet base-devel git just ansible || \
	{ echo "Error: Failed during dependency installation. Please check the error above."; exit 1; }

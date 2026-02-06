-- DAP configuration overrides
-- Disables auto-open of dap-ui and adds notifications for debug events

return {
  -- Python: skip library code (including Dash reloader)
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Wrap dap.run to inject python defaults
      local original_run = dap.run
      dap.run = function(config, opts)
        if config.type == "python" then
          config = vim.tbl_extend("keep", config, {
            justMyCode = true,
            subProcess = false, -- Don't debug reloader subprocess
          })
        end
        return original_run(config, opts)
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      -- Remove LazyVim's auto-open/close listeners
      dap.listeners.after.event_initialized["dapui_config"] = nil
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil

      -- Add notification listeners instead
      dap.listeners.after.event_initialized["dap_notify"] = function()
        Snacks.notify.info("Debugger started", { title = "DAP" })
      end

      dap.listeners.before.event_terminated["dap_notify"] = function()
        Snacks.notify.info("Debugger terminated", { title = "DAP" })
      end

      dap.listeners.before.event_exited["dap_notify"] = function()
        Snacks.notify.info("Debugger exited", { title = "DAP" })
      end

      dap.listeners.after.event_stopped["dap_notify"] = function(_, body)
        local reason = body.reason or "unknown"
        if reason == "breakpoint" then
          Snacks.notify.info("Breakpoint hit", { title = "DAP" })
        elseif reason == "exception" then
          Snacks.notify.error("Exception: " .. (body.description or "unknown"), { title = "DAP" })
        elseif reason == "step" then
          -- Don't notify on every step
        else
          Snacks.notify.info("Stopped: " .. reason, { title = "DAP" })
        end
      end

      dap.listeners.after.event_output["dap_notify"] = function(_, body)
        if body.category == "stderr" and body.output then
          local output = body.output:gsub("^%s+", ""):gsub("%s+$", "")
          if output:lower():match("error") and #output > 0 then
            Snacks.notify.error(output:sub(1, 200), { title = "DAP" })
          end
        end
      end
    end,
  },
}

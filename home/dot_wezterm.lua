local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Belge (terminal.sexy)"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14

config.keys = {
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

local runtime_dir = os.getenv("XDG_RUNTIME_DIR")
if runtime_dir then
	local socks = wezterm.glob(runtime_dir .. "/wayland-[0-9]*")
	for _, sock_path in ipairs(socks) do
		if not sock_path:match("%.lock$") then
			local sock_name = sock_path:match(".*/(.*)$")
			wezterm.log_info("Detected Wayland socket: " .. sock_name)

			config.set_environment_variables = {
				WAYLAND_DISPLAY = sock_name,
			}
			break
		end
	end
end

return config

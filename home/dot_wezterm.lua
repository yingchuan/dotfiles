local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Belge (terminal.sexy)"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14

local runtime_dir = os.getenv("XDG_RUNTIME_DIR")

if runtime_dir then
	local pattern = runtime_dir .. "/wayland-*"
	local socks = wezterm.glob(pattern)

	if #socks > 0 then
		local sock_path = socks[1]
		local sock_name = sock_path:match(".*/(.*)$")

		config.environment = {
			WAYLAND_DISPLAY = sock_name,
		}
	end
end

return config

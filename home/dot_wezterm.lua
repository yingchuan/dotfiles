local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

config.color_scheme = "Belge (terminal.sexy)"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14

config.keys = {
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ShowDebugOverlay },
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

config.ssh_domains = {
	{
		-- This name identifies the domain
		name = "amd-32g2T",
		-- The hostname or address to connect to. Will be used to match settings
		-- from your ssh config file
		remote_address = "192.168.1.165",
		-- The username to use on the remote host
		username = "richardchen",
	},
}

config.default_workspace = "Development"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true

-- key bindings
-- set leader
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 3000 }
config.keys = {
	------------------------------------------------------------------
	-- Window / Tab
	------------------------------------------------------------------
	-- Prefix + c  → 新 tab（= tmux window）
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

	-- Prefix + ,  → 重新命名 tab
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename tab",
			action = wezterm.action_callback(function(win, _, line)
				if line then
					win:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Prefix + n / p  → 下一 / 上一 tab
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

	------------------------------------------------------------------
	-- Split
	------------------------------------------------------------------
	-- Prefix + -  → 水平 split（下）
	{ key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down", size = { Percent = 50 } }) },

	-- Prefix + _  → 垂直 split（右）
	{ key = "=", mods = "LEADER", action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }) },

	------------------------------------------------------------------
	-- Pane navigation：Prefix + h / j / k / l
	------------------------------------------------------------------
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	------------------------------------------------------------------
	-- Pane resize：Alt + h/j/k/l（同 oh‑my‑tmux）
	------------------------------------------------------------------
	{ key = "h", mods = "ALT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "ALT", action = act.AdjustPaneSize({ "Down", 3 }) },
	{ key = "k", mods = "ALT", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "l", mods = "ALT", action = act.AdjustPaneSize({ "Right", 3 }) },

	------------------------------------------------------------------
	-- Pane zoom：Prefix + z（與 tmux 的 toggle‑zoom 一致）
	------------------------------------------------------------------
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	------------------------------------------------------------------
	-- 2️⃣  Workspace（原設計，改用大寫 C）
	------------------------------------------------------------------
	{
		key = "c",
		mods = "LEADER|SHIFT", -- 大寫 C
		action = wezterm.action_callback(function(win, pane)
			win:gui_window()
				:prompt_for_input_async({ description = "New workspace name:", default = "proj" }, function(_, name)
					if name and #name > 0 then
						mux.switch_to_workspace({
							name = name,
							spawn = { cwd = pane:get_current_working_dir() },
						})
					end
				end)
		end),
	},

	-- Workspace 快速切：Prefix + s → Fuzzy 選單
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i), -- '1' .. '9'
		mods = "LEADER",
		-- ActivateTab 的索引從 0 開始，所以 i-1
		action = act.ActivateTab(i - 1),
	})
end

----------------------------------------------------------------------
-- 3️⃣  狀態列：左側顯示 Workspace ⟡ Tab 標題（簡配版）
----------------------------------------------------------------------
wezterm.on("update-status", function(win, _)
	local ws = mux.get_active_workspace()
	local tab = win:active_tab()
	local name = (tab and tab:get_title()) or ("[" .. (tab and tab.tab_index or "?") .. "]")

	win:set_left_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Text = " 󰹞 " .. ws .. "  " .. name .. " " },
	}))
end)

wezterm.on("update-status", function(window, pane)
	local username = os.getenv("USER") or os.getenv("USERNAME") or "unknown"

	local success, hostname_output, stderr = wezterm.run_child_process({ "hostname" })
	local hostname = "unknown"
	if success then
		hostname = hostname_output:gsub("%s+", "")
	end

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#ffffff" } }, -- Changed to white
		{ Text = " │ " }, -- Just the icon
		{ Foreground = { Color = "#75b5aa" } }, -- Keep username in teal
		{ Text = username }, -- Just the username
		{ Foreground = { Color = "#ffffff" } }, -- Already white
		{ Text = " │ " }, -- The separator
		{ Foreground = { Color = "#ffb86c" } }, -- Keep hostname in orange
		{ Text = hostname .. " " }, -- The hostname
	}))
end)

-- monitor format-tab-title event from the self-defined title
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane

	-- fetch the title
	local title = pane.title
	local is_ssh = false

	if pane.domain_name and pane.domain_name ~= "local" then
		is_ssh = true
	end

	local display_title = ""
	if is_ssh then
		display_title = "🌐" .. " " .. title
	else
		display_title = title
	end

	return tab.tab_index + 1 .. ": " .. display_title
end)

return config

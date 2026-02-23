local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.choices_from_dir = function(dir)
	local f = io.popen("ls " .. dir)

	local choices = {}
	if f then
		for filename in f:lines() do
			wezterm.log_info(filename)
			table.insert(choices, { label = dir .. filename, id = dir .. filename })
		end

		f:close()
	end

	return choices
end

M.choices_from_dirs = function(dirs)
	local choices = {}

	for _i, dir in ipairs(dirs) do
		wezterm.log_info(dir)

		for _, choice in ipairs(M.choices_from_dir(dir)) do
			table.insert(choices, choice)
		end
	end

	wezterm.log_info(choices)
	return choices
end

M.show_not_choices = function(window, pane)
	window:perform_action(
		act.InputSelector {
			title = "Error",
			choices = {
				{ label = wezterm.format({
					{ Foreground = { AnsiColor = 'Red' } },
					{ Attribute = { Intensity = 'Bold' } },
					{ Text = 'No items found. Press ESC to close' }
				})
				},
			},
			action = wezterm.action_callback(function() end),
		}, pane)
end

M.dir_name_from_path = function(str)
	local last_slash_index = str:find("[^/]*$")

	if last_slash_index then
		return str:sub(last_slash_index)
	else
		return str
	end
end

M.create_ws_and_execute_command = function(window, pane, cmd, id, label)
	window:perform_action(wezterm.action_callback(function(_win, _pane)
		local mux = wezterm.mux

		mux.spawn_window {
			workspace = M.dir_name_from_path(label),
			cwd = label,
			args = cmd,
		}
		-- Explicitly focus the new workspace
		mux.set_active_workspace(M.dir_name_from_path(label))
	end), pane)
end

M.window_with_options = function(window, pane, choices, cmd)
	window:perform_action(
		act.InputSelector {
			title = "Select Directory",
			choices = choices,
			fuzzy = true,
			action = wezterm.action_callback(function(cb_window, cb_pane, id, label)
				if not id then return end -- User escaped the menu
				M.create_ws_and_execute_command(cb_window, cb_pane, cmd, id, label)
			end),
		},
		pane
	)
end

M.setup = function(config, dirs, key, mods, cmd)
	config.keys = config.keys or {}
	table.insert(config.keys, {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(window, pane)
			local choices = M.choices_from_dirs(dirs)

			if not choices or #choices == 0 then
				M.show_not_choices(window, pane)
			else
				M.window_with_options(window, pane, choices, cmd)
			end
		end),
	})
end

return M

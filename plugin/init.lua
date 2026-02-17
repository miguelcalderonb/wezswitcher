local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}
M.get_choices = function(dir)

	wezterm.log_info("ls " .. dir)
	local f = io.popen("ls " .. dir)

	wezterm.log_info(f)
	local choices = {}
	if f then
		wezterm.log_info("here at file")
		for filename in f:lines() do
			wezterm.log_info(filename)
			table.insert(choices, { label = filename, id = dir .. filename})
		end

		f:close()

	end

	return choices
end

M.show_options = function(dirs)
        local choices = {}

	for _i, dir in ipairs(dirs) do
		wezterm.log_info(dir)

		for _i, choice in ipairs(M.get_choices(dir)) do
			table.insert(choices, choice)
		end
	end

	wezterm.log_info(choices)
	return choices
end

M.setup =  function(config, dirs, key, mods)
  config.keys = config.keys or {}
  table.insert(config.keys, {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(window, pane)
      -- Transform the 'dirs' vector into the format InputSelector expects
      local choices = M.show_options(dirs)
      wezterm.log_info(choices)

      window:perform_action(
        act.InputSelector {
          title = "Select Directory",
          choices = choices,
          fuzzy = true,
          action = wezterm.action_callback(function(window, pane, id, label)
            if not id then return end -- User escaped the menu
            wezterm.log_info(id)
		wezterm.log_info(label)
            -- EXECUTE YOUR FUNCTION HERE
            -- Example: Change the current pane's Directory
	
          end),
        },
        pane
      )
    end),
  })
end

return M

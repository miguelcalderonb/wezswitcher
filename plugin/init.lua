local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}
local function get_choices(dir)

	local f = io.popen("ls -l " .. dir)

	local choices = {}
	if f then
		for filename in f:lines() do
			choices.insert(choices, { label = filename, id = filename})
		end

		f:close()

	end

	return choices
end

M.show_options = function(dirs)
        local choices = {}

	for dir in dirs() do
		choices.insert(choices, get_choices(dir))
	end

	return choices
end

M.setup =  function(config, dirs, key, mods)
  table.insert(config.keys, {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(window, pane)
      -- Transform the 'dirs' vector into the format InputSelector expects
      local choices = M.show_options(dirs)

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
            -- Example: Change the current pane's directory
          end),
        },
        pane
      )
    end),
  })
end


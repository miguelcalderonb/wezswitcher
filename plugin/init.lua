local wezterm = require 'wezterm'

local M = {}

local function handle_selection(window, pane, id, label)

	wezterm.log.info("handle selection")

end

wezterm.action_callback("switch_project", handle_selection)

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

M.show_options = function(window, pane, dirs)
        local choices = []

	for dir in dirs() do
		choices.insert(choices, get_choices(dir))
	end

	window.show_input_selector({
		title = "Choose an action",
		choices = choices,
action = wezterm.action.CallbackName("switch_project")

	})
end

M.apply_to_config = function(config, dirs, key, mods)

   	config.keys = wezterm.table.insert(config.keys or {}, {
        key = key,
        mods = mods, -- Example keybinding: Alt+o
        action = wezterm.action.Multiple {
            wezterm.action.EmitEvent("trigger-my-options"),
        },
    })

    -- Listen for the custom event and call show_options
    wezterm.on("trigger-my-options", function(window, pane)
        M.show_options(window, pane, dirs)
    end)

end

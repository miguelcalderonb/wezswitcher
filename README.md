# Wezswitcher
This is a plugin that allows you to switch between projects in a fast and easy way.

## Config Params
| Param | Description| Example |
| :-- | :-- | :-- |
| dirs | Vector of directories | {"/my/directory/projects"} |
| key | Key to call the plugin | "p" |
| mods | Mod to call the plugin | "LEADER"|
| cmd | Vector of command | {"nvim"} |

## Installation

### Clone Repository

```bash
git clone git@github.com:miguelcalderonb/wezswitcher.git

mv wezwitcher ~/.config/wezterm/plugins
```
### Add to wezterm.lua
```lua

-- Add /home/<user>/.config/wezterm/plugins/wezswitcher
package.path = package.path .. ";"  .. wezterm.config_dir .."/plugins/wezswitcher/?.lua"

require("plugins.wezswitcher.plugin").setup(config, {"/home/<user>/projects"}, "p", "LEADER", {"zsh", "-i", "-c", "nvim"})
-
```


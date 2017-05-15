-- Sets up all non built-in gameplay features specific to this quest.

-- Usage: require("scripts/features")

-- Features can be enabled to disabled independently by commenting
-- or uncommenting lines below.

require("scripts/debug")
require("scripts/equipment")
require("scripts/dungeons")
require("scripts/menus/game_over")
require("scripts/menus/dialog_box")
require("scripts/menus/pause")
require("scripts/hud/hud")

if sol.main.get_os() ~= "iOS" then
  require("scripts/mouse_control")
else
  require("scripts/touch_control")
end

return true

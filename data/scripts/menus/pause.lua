-- Script that creates a pause menu for a game.

-- Usage:
-- local pause_manager = require("scripts/menus/pause")
-- local pause_menu = pause_manager:create(game)

local inventory_builder = require("scripts/menus/pause_inventory")
local map_builder = require("scripts/menus/pause_map")
local quest_status_builder = require("scripts/menus/pause_quest_status")
local options_builder = require("scripts/menus/pause_options")

local pause_manager = {}

-- Creates a pause menu for the specified game.
function pause_manager:create(game)

  local pause_menu = {}
  local pause_submenus

  function pause_menu:on_started()

    -- Define the available submenus.

    pause_submenus = {  -- Array of submenus (inventory, map, etc.).
      inventory_builder:new(game),
      map_builder:new(game),
      quest_status_builder:new(game),
      options_builder:new(game),
    }

    -- Select the submenu that was saved if any.
    local submenu_index = game:get_value("pause_last_submenu") or 1
    if submenu_index <= 0
        or submenu_index > #pause_submenus then
      submenu_index = 1
    end
    game:set_value("pause_last_submenu", submenu_index)

    -- Play the sound of pausing the game.
    sol.audio.play_sound("pause_open")

    -- Start the selected submenu.
    sol.menu.start(pause_menu, pause_submenus[submenu_index])
  end

  function pause_menu:on_finished()
    pause_submenus = nil
    if game.set_custom_command_effect ~= nil then
      game:set_custom_command_effect("action", nil)
      game:set_custom_command_effect("attack", nil)
    end
  end

  return pause_menu
end

return pause_manager


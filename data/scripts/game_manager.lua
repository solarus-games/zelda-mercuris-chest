-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

local dialog_box_manager = require("scripts/dialog_box")
local hud_manager = require("scripts/hud/hud")
local pause_manager = require("scripts/menus/pause")
local dungeon_manager = require("scripts/dungeons")
local equipment_manager = require("scripts/equipment")

local game_manager = {}

-- Sets initial values for a new savegame of this quest.
local function initialize_new_savegame(game)

  -- TODO
  game:set_starting_location("test_map", "initial_position")

  -- Initially give 3 hearts, the first tunic and the first wallet.
  game:set_max_life(12)
  game:set_life(game:get_max_life())
  game:get_item("tunic"):set_variant(1)
  game:set_ability("tunic", 1)
  game:get_item("rupee_bag"):set_variant(1)
end

-- Creates a game ready to be played.
function game_manager:create(file)

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- This is a new savegame file.
    initialize_new_savegame(game)
  end
 
  local dialog_box
  local hud
  local pause_menu

  -- Function called when the player runs this game.
  function game:on_started()

    dungeon_manager:create(game)
    equipment_manager:create(game)
    dialog_box = dialog_box_manager:create(game)
    hud = hud_manager:create(game)
    pause_menu = pause_manager:create(game)
  end

  -- Function called when the game stops.
  function game:on_finished()

    dialog_box:quit()
    dialog_box = nil
    hud:quit()
    hud = nil
    pause_menu = nil
  end

  -- Function called when the game is paused.
  function game:on_paused()

    -- Tell the HUD we are paused.
    hud:on_paused()

    -- Start the pause menu.
    sol.menu.start(game, pause_menu)
  end

  -- Function called when the game is paused.
  function game:on_unpaused()

    -- Tell the HUD we are no longer paused.
    hud:on_unpaused()

    -- Stop the pause menu.
    sol.menu.stop(pause_menu)
  end

  -- Function called when the player goes to another map.
  function game:on_map_changed(map)

    -- Notify the HUD (some HUD elements may want to know that).
    hud:on_map_changed(map)
  end

  function game:get_dialog_box()
    return dialog_box
  end

  -- Returns whether the HUD is currently shown.
  function game:is_hud_enabled()
    return hud:is_enabled()
  end

  -- Enables or disables the HUD.
  function game:set_hud_enabled(enable)
    return hud:set_enabled(enable)
  end

  -- Return the HUD.
  function game:get_hud()
    return hud
  end

  function game:get_player_name()
    return self:get_value("player_name")
  end

  function game:set_player_name(player_name)
    self:set_value("player_name", player_name)
  end

  -- Returns whether the current map is in the inside world.
  function game:is_in_inside_world()
    return self:get_map():get_world() == "inside_world"
  end

  -- Returns whether the current map is in the outside world.
  function game:is_in_outside_world()
    return self:get_map():get_world() == "outside_world"
  end

  -- Returns whether the current map is in a dungeon.
  function game:is_in_dungeon()
    return self:get_dungeon() ~= nil
  end

  return game
end

return game_manager


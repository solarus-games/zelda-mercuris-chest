-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")
local dialog_box_manager = require("scripts/dialog_box")
require("scripts/hud/hud")
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
  local pause_menu

  -- Function called when the player runs this game.
  game:register_event("on_started", function()

    dungeon_manager:create(game)
    equipment_manager:create(game)
    dialog_box = dialog_box_manager:create(game)
    pause_menu = pause_manager:create(game)
  end)

  -- Function called when the game stops.
  game:register_event("on_finished", function()

    dialog_box:quit()
    dialog_box = nil
    pause_menu = nil
  end)

  -- Function called when the game is paused.
  game:register_event("on_paused", function()

    -- Tell the HUD we are paused.
    hud:on_paused()

    -- Start the pause menu.
    local to_front = false  -- Show it behind the HUD.
    sol.menu.start(game, pause_menu, false)
  end)

  -- Function called when the game is paused.
  game:register_event("on_unpaused", function()

    -- Tell the HUD we are no longer paused.
    hud:on_unpaused()

    -- Stop the pause menu.
    sol.menu.stop(pause_menu)
  end)

  function game:get_dialog_box()
    return dialog_box
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


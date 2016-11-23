-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")

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

  function game:get_player_name()
    return self:get_value("player_name")
  end

  function game:set_player_name(player_name)
    self:set_value("player_name", player_name)
  end

  -- Returns whether the current map is in the inside world.
  function game:is_in_inside_world()
    return game:get_map():get_world() == "inside_world"
  end

  -- Returns whether the current map is in the outside world.
  function game:is_in_outside_world()
    return game:get_map():get_world() == "outside_world"
  end

  -- Returns whether the current map is in a dungeon.
  function game:is_in_dungeon()
    return game:get_dungeon() ~= nil
  end

  return game
end

return game_manager


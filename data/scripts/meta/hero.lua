-- Provides additional features to the hero type for this quest.

require("scripts/multi_events")

local hero_meta = sol.main.get_metatable("hero")

-- Detect the position of the hero to mark visited rooms in dungeons.
hero_meta:register_event("on_position_changed", function(hero)

  local map = hero:get_map()
  local game = map:get_game()
  local dungeon = game:get_dungeon()

  if dungeon == nil then
    return
  end

  local map_width, map_height = map:get_size()
  local room_width, room_height = 320, 240  -- TODO don't hardcode these numbers
  local num_columns = math.floor(map_width / room_width)

  local hero_x, hero_y = hero:get_center_position()
  local column = math.floor(hero_x / room_width)
  local row = math.floor(hero_y / room_height)
  local room = row * num_columns + column + 1

  game:set_explored_dungeon_room(nil, nil, room)
end)

return true

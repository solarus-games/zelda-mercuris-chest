-- Provides additional features to the sensor type for this quest.

require("scripts/multi_events")

local sensor_meta = sol.main.get_metatable("sensor")

sensor_meta:register_event("on_activated", function(sensor)

  local hero = sensor:get_map():get_hero()
  local game = sensor:get_game()
  local map = sensor:get_map()
  local name = sensor:get_name()

  if name == nil then
    return
  end

  -- Sensors named "to_layer_X_sensor" move the hero on that layer.
  -- TODO use a custom entity or a wall to block enemies and thrown items?
  if name:match("^layer_up_sensor") then
    local x, y, layer = hero:get_position()
    if layer < map:get_max_layer() then
      hero:set_position(x, y, layer + 1)
    end
    return
  elseif name:match("^layer_down_sensor") then
    local x, y, layer = hero:get_position()
    if layer > map:get_min_layer() then
      hero:set_position(x, y, layer - 1)
    end
    return
  end

  -- Sensors prefixed by "save_solid_ground_sensor" are where the hero come back
  -- when falling into a hole or other bad ground.
  if name:match("^save_solid_ground_sensor") then
    hero:save_solid_ground()
    return
  end

  -- Sensors prefixed by "reset_solid_ground_sensor" clear any place for the hero
  -- to come back when falling into a hole or other bad ground.
  if name:match("^reset_solid_ground_sensor") then
    hero:reset_solid_ground()
    return
  end

  -- Sensors named "open_quiet_X_sensor" silently open doors prefixed with "X".
  local door_prefix = name:match("^open_quiet_([a-zA-X0-9_]+)_sensor")
  if door_prefix ~= nil then
    map:set_doors_open(door_prefix, true)
    return
  end

  -- Sensors named "close_quiet_X_sensor" silently close doors prefixed with "X".
  door_prefix = name:match("^close_quiet_([a-zA-X0-9_]+)_sensor")
  if door_prefix ~= nil then
    map:set_doors_open(door_prefix, false)
    return
  end

  -- Sensors named "open_loud_X_sensor" open doors prefixed with "X".
  local door_prefix = name:match("^open_loud_([a-zA-X0-9_]+)_sensor")
  if door_prefix ~= nil then
    map:open_doors(door_prefix)
    return
  end

  -- Sensors named "close_loud_X_sensor" close doors prefixed with "X".
  door_prefix = name:match("^close_loud_([a-zA-X0-9_]+)_sensor")
  if door_prefix ~= nil then
    map:close_doors(door_prefix)
    return
  end

  -- Sensors named "start_dark_sensor" put the map in the dark.
  local dark_prefix = name:match("^start_dark_sensor")
  if dark_prefix ~= nil then
    map:set_light(0)
    return
  end

  -- Sensors named "stop_dark_sensor" put back the map in the light.
  local dark_prefix = name:match("^stop_dark_sensor")
  if dark_prefix ~= nil then
    map:set_light(1)
    return
  end

end)

sensor_meta:register_event("on_collision_explosion", function(sensor)

  local game = sensor:get_game()
  local map = sensor:get_map()
  local name = sensor:get_name()

  if name == nil then
    return
  end

  -- Sensors named "weak_floor_X_sensor" detect explosions to disable dynamic tiles prefixed with "weak_floor_X_closed".
  local prefix = name:match("^(weak_floor_[a-zA-X0-9_]+)_sensor")
  if prefix ~= nil then
    sol.audio.play_sound("secret")
    map:set_entities_enabled(prefix .. "_closed", false)

    local dungeon_index = game:get_dungeon_index()
    if dungeon_index ~= nil then
      local floor_name = game:get_floor_name()
      if floor_name ~= nil then
        local savegame_variable = "d" .. dungeon_index .. "_" .. floor_name .. "_" .. prefix
        game:set_value(savegame_variable, true)
      end
    end

    sensor:set_enabled(false)
  end
end)

sensor_meta:register_event("on_activated_repeat", function(sensor)

  local game = sensor:get_game()
  local map = sensor:get_map()
  local name = sensor:get_name()

  if name == nil then
    return
  end

  -- Sensors called open_house_xxx_sensor automatically open an outside house door tile.
  local door_name = name:match("^open_house_([a-zA-X0-9_]+)_sensor")
  if door_name ~= nil then
    local door = map:get_entity(door_name)
    if door ~= nil then
      if hero:get_direction() == 1
	         and door:is_enabled() then
        door:set_enabled(false)
        sol.audio.play_sound("door_open")
      end
    end
  end
end)

sensor_meta:register_event("on_created", function(sensor)

  local game = sensor:get_game()
  local map = sensor:get_map()
  local name = sensor:get_name()

  if name == nil then
    return
  end

  local prefix = name:match("^(weak_floor_[a-zA-X0-9_]+)_sensor")
  if prefix ~= nil then
    local dungeon_index = game:get_dungeon_index()
    if dungeon_index ~= nil then
      local floor_name = game:get_floor_name()
      if floor_name ~= nil then
        local savegame_variable = "d" .. dungeon_index .. "_" .. floor_name .. "_" .. prefix
        if game:get_value(savegame_variable) then
          map:set_entities_enabled(prefix .. "_closed", false)
        end
      end
    end
  end
end)

return true

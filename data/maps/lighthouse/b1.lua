local map = ...

local function star_sensor_A_activated()
  sol.audio.play_sound("secret")
  map:set_entities_enabled("star_sensor_A", false)
  map:set_entities_enabled("star_sensor_B", true)
  map:set_entities_enabled("star_tile_A", false)
  map:set_entities_enabled("star_tile_B", true)
  map:set_entities_enabled("star_floor_A", false)
  map:set_entities_enabled("star_floor_B", true)

  for sensor in map:get_entities("star_sensor_B") do
    sensor:set_activated(false)
  end
end

local function star_sensor_B_activated()
  sol.audio.play_sound("secret")
  map:set_entities_enabled("star_sensor_A", true)
  map:set_entities_enabled("star_sensor_B", false)
  map:set_entities_enabled("star_tile_A", true)
  map:set_entities_enabled("star_tile_B", false)
  map:set_entities_enabled("star_floor_A", true)
  map:set_entities_enabled("star_floor_B", false)

  for sensor in map:get_entities("star_sensor_A") do
    sensor:set_activated(false)
  end
end

-- Star tiles puzzle init
local function star_tiles_puzzle_init()
  for sensor in map:get_entities("star_sensor_A") do
    sensor.on_activated = star_sensor_A_activated
  end
  for sensor in map:get_entities("star_sensor_B") do
    sensor.on_activated = star_sensor_B_activated
  end
end

-- Key room puzzle init
local function key_room_puzzle_init()
  map:set_doors_open("locked_door_16", true)

  for enemy in map:get_entities("key_monster") do
    enemy.on_dead = key_monster_dead
  end
end

-- Key room puzzle monsters
local function key_monster_dead(enemy)
  if map:get_entities_count("key_monster") == 0 then
    sol.audio.play_sound("secret")
    map:open_doors("locked_door_16")
  end
end

-- Key room puzzle door
function door_sensor_16:on_activated()
  map:close_doors("locked_door_16")
  self:set_enabled(false)
end

-- Map starting main event function
function map:on_started()
  star_tiles_puzzle_init()
  key_room_puzzle_init()
end

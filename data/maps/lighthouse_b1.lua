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

function DS1:on_activated()
  map:close_doors("LD1")
  self:set_enabled(false)
end

-- Key room puzzle
function key_monster_dead(enemy)
  if map:get_entities_count("key_monster") == 0 then
    sol.audio.play_sound("secret")    
    map:open_doors("LD1")
  end
end
for enemy in map:get_entities("key_monster") do
  enemy.on_dead = key_monster_dead
end

function map:on_started()
  -- Star tiles puzzle
  for sensor in map:get_entities("star_sensor_A") do
    sensor.on_activated = star_sensor_A_activated
  end
  for sensor in map:get_entities("star_sensor_B") do
    sensor.on_activated = star_sensor_B_activated
  end

  -- Key room puzzle
  map:set_doors_open("LD1", true)
end



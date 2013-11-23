local map = ...
local game = map:get_game()

function map:on_started()

  -- Initially open room A (small room with two skeletons).
  map:set_doors_open("room_a_door", true)

  -- Initially open room D (small room with a hardat beetle).
  map:set_doors_open("room_d_door", true)

  -- Initially open room E (small room with two skeletons and the map).
  map:set_doors_open("room_e_door", true)
  if not game:get_value("rail_temple_map_chest") then
    room_e_chest:set_enabled(false)
  end

  -- Train barrier A.
  if game:get_value("rail_temple_train_barrier_a") then
    train_barrier_a_switch:set_activated(true)
  end

  -- Disable the blocks puzzle chest (rail 1) if not found yet.
  if not game:get_value("rail_temple_rail_1_chest") then
    room_c_chest:set_enabled(false)
  end

  -- Place the statue of room F on the switch if it was done once.
  if game:get_value("rail_temple_1f_room_f_statue") then
    room_f_statue:set_position(1280, 2565)
    map:set_doors_open("room_f_door", true)
    room_f_switch_pot:remove()
  end
end

local function room_a_enemy_dead(enemy)

  if map:get_entities_count("room_a_enemy") == 0
      and not room_a_door:is_open() then
    -- The last enemy of the room is dead: open the doors.
    sol.audio.play_sound("secret")
    map:open_doors("room_a_door")
  end
end
for enemy in map:get_entities("room_a_enemy") do
  enemy.on_dead = room_a_enemy_dead
end

local function close_room_a_sensor_activated()
  if map:get_entities_count("room_a_enemy") > 0
      and room_a_door:is_open() then
    -- Close the doors of this room.
    map:close_doors("room_a_door")
  end
end
for sensor in map:get_entities("close_room_a_sensor") do
  sensor.on_activated = close_room_a_sensor_activated
end

function train_barrier_a_switch:on_activated()

  map:move_camera(2848, 2856, 250, function()
    sol.audio.play_sound("secret")
    map:open_doors("train_barrier_a_door")
  end)
end

function room_b_door_switch:on_activated()

  if room_b_door:is_closed() then
    sol.audio.play_sound("secret")
    map:open_doors("room_b_door")
  end
end

local function room_c_enemy_dead(enemy)

  if map:get_entities_count("room_c_enemy") == 0
      and not room_c_chest:is_enabled() then
    -- The last enemy of the room is dead: show the chest.
    local x, y = room_c_chest:get_position()
    map:move_camera(x, y, 250, function()
      sol.audio.play_sound("chest_appears")
      room_c_chest:set_enabled(true)
    end)
  end
end
for enemy in map:get_entities("room_c_enemy") do
  enemy.on_dead = room_c_enemy_dead
end

function room_d_enemy:on_dead()

  if not room_d_door:is_open() then
    -- The enemy of the room is dead: open the doors.
    sol.audio.play_sound("secret")
    map:open_doors("room_d_door")
  end
end

local function close_room_d_sensor_activated()
  if room_d_enemy ~= nil
      and room_d_door:is_open() then
    -- Close the doors of this room.
    map:close_doors("room_d_door")
  end
end
for sensor in map:get_entities("close_room_d_sensor") do
  sensor.on_activated = close_room_d_sensor_activated
end

local function close_room_e_sensor_activated()
  if room_e_enemy ~= nil
      and room_e_door:is_open() then
    -- Close the doors of this room.
    map:close_doors("room_e_door")
  end
end
for sensor in map:get_entities("close_room_e_sensor") do
  sensor.on_activated = close_room_e_sensor_activated
end

local function room_e_enemy_dead(enemy)

  if map:get_entities_count("room_e_enemy") == 0
      and not room_e_chest:is_enabled() then
    -- The last enemy of the room is dead: show the chest and open the door.
    sol.audio.play_sound("chest_appears")
    room_e_chest:set_enabled(true)
    map:open_doors("room_e_door")
  end
end
for enemy in map:get_entities("room_e_enemy") do
  enemy.on_dead = room_e_enemy_dead
end

function open_room_f_switch:on_activated()

  map:open_doors("room_f")
  game:set_value("rail_temple_1f_room_f_statue", true)
end

function open_room_f_switch:on_inactivated()

  map:close_doors("room_f")
  game:set_value("rail_temple_1f_room_f_statue", false)
end



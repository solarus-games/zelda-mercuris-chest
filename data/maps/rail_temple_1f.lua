local map = ...

function map:on_started()

  -- Initially open room A (small room with two skeletons).
  map:set_doors_open("room_a_door", true)

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


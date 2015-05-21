local map = ...
local game = map:get_game()

local railway_points_should_be_on = {
  1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 15, 17, 18, 19, 20
}
local railway_points_should_be_off = {
  3, 12, 13
}

local set_railway_points_puzzle_solved

function map:on_started()

  -- Initially open room A (small room with two skeletons).
  map:set_doors_open("room_a_door", true)

  -- Room C (blocks puzzle).
  if game:get_value("rail_temple_1f_blocks_puzzle") then
    map:set_blocks_puzzle_solved_configuration()
  end
  if not game:get_value("rail_temple_rail_1_chest") then
    room_c_chest:set_enabled(false)
  end

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

  -- Train barrier B.
  if game:get_value("rail_temple_train_barrier_b") then
    train_barrier_b_switch:set_activated(true)
  end

  -- Place the statue of room F on the switch if it was done once.
  if game:get_value("rail_temple_1f_room_f_statue") then
    room_f_statue:set_position(1280, 2565)
    map:set_doors_open("room_f_door", true)
    room_f_switch_pot:remove()
  end

  -- Railway points maze.
  map:set_entities_enabled("railway_points_on_", false)

  -- Set up invisible walls in the maze.
  sol.timer.start(100, function()
    if hero:get_animation() ~= "minecart_driving" then
      map:set_entities_enabled("railway_points_wall_", false)
    else
      for switch in map:get_entities("railway_points_switch_") do
        local switch_number = switch:get_name():match("railway_points_switch_(%d+)")
        assert(switch_number ~= nil)
        local turned_on = (switch:get_sprite():get_direction() == 1)
        map:set_entities_enabled("railway_points_wall_on_" .. switch_number .. "_", turned_on)
        map:set_entities_enabled("railway_points_wall_off_" .. switch_number .. "_", not turned_on)
      end
    end
    return true  -- Repeat the timer.
  end)

  if game:get_value("rail_temple_1f_railway_points_puzzle") then
    -- The puzzle is solved.
    set_railway_points_puzzle_solved()
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

function train_barrier_b_switch:on_activated()

  sol.audio.play_sound("secret")
  map:open_doors("train_barrier_b_door")
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
      and room_e_door:is_open()
      and not game:get_value("rail_temple_map_chest") then
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

-- Railway points maze.
local function update_railway_points_from_switch(switch)

  local switch_number = switch:get_name():match("railway_points_switch_(%d+)")
  assert(switch_number ~= nil)

  local turned_on = (switch:get_sprite():get_direction() == 1)
  map:get_entity("railway_points_on_" .. switch_number):set_enabled(turned_on)
  map:get_entity("railway_points_off_" .. switch_number):set_enabled(not turned_on)
end

local function check_railway_points_switch_puzzle()

  if game:get_value("rail_temple_1f_railway_points_puzzle") then
    -- Already saved as solved.
    return
  end

  for _, index in ipairs(railway_points_should_be_on) do
    local switch = map:get_entity("railway_points_switch_" .. index)
    if switch:get_sprite():get_direction() ~= 1 then
      return
    end
  end
  for _, index in ipairs(railway_points_should_be_off) do
    local switch = map:get_entity("railway_points_switch_" .. index)
    if switch:get_sprite():get_direction() ~= 0 then
      return
    end
  end

  -- The puzzle is just solved.
  sol.audio.play_sound("secret")
  game:set_value("rail_temple_1f_railway_points_puzzle", true)
end

local function railway_point_switch_activated(switch)

  local direction = switch:get_sprite():get_direction()
  switch:get_sprite():set_direction(1 - direction)
  sol.timer.start(map, 500, function()
    switch:set_activated(false)
  end)
  update_railway_points_from_switch(switch)
  check_railway_points_switch_puzzle()
end
for switch in map:get_entities("railway_points_switch_") do
  switch.on_activated = railway_point_switch_activated
end

function set_railway_points_puzzle_solved()

  for _, index in ipairs(railway_points_should_be_on) do
    local switch = map:get_entity("railway_points_switch_" .. index)
    switch:get_sprite():set_direction(1)
    update_railway_points_from_switch(switch)
  end
  for _, index in ipairs(railway_points_should_be_off) do
    local switch = map:get_entity("railway_points_switch_" .. index)
    switch:get_sprite():set_direction(0)
    update_railway_points_from_switch(switch)
  end
end

-- Blocks puzzle (room C).

-- Called when a block has just been moved.
local function blocks_puzzle_block_moved()

  -- A block was just moved. Check if this solves the puzzle.
  if not game:get_value("rail_temple_1f_blocks_puzzle") then

    local solved = true
    for block in map:get_entities("blocks_puzzle_block") do
      if block:is_on_rail() then
        solved = false
        break
      end
    end

    if solved then
      -- Just solved the puzzle!
      sol.audio.play_sound("secret")
      game:set_value("rail_temple_1f_blocks_puzzle", true)
    end
  end
end

-- Coordinates of each rail position to check for the presence of blocks
-- (top-left corner of a 16x16 square).
local blocks_puzzle_rails_positions_to_check = {
  {2544, 2352},
  {2768, 2352},
  {2400, 2448},
  {2368, 2320},
  {2432, 2400},
  {2368, 2304},
  {2416, 2400},
  {2480, 2400},
  {2512, 2368},
  {2352, 2368},
  {2400, 2400},
  {2352, 2320},
  {2720, 2304},
  {2400, 2416},
  {2512, 2352},
  {2768, 2384},
  {2720, 2272},
  {2768, 2368},
  {2400, 2432},
  {2816, 2320},
  {2448, 2400},
  {2768, 2400},
  {2720, 2336},
  {2352, 2352},
  {2768, 2336},
  {2352, 2336},
  {2768, 2320},
  {2832, 2304},
  {2800, 2320},
  {2560, 2352},
  {2784, 2320},
  {2720, 2288},
  {2720, 2352},
  {2528, 2352},
  {2464, 2400},
  {2704, 2352},
}

-- Returns whether the specified block of the puzzle is on the railway.
-- If none of then is, then the puzzle is solved.
local function blocks_puzzle_block_is_on_rail(block)

  local overlaps_rail = false

  -- This code assumes that blocks have a size of 16x16.
  local block_x, block_y = block:get_position()
  local origin_x, origin_y = block:get_origin()
  local x1, y1 = block_x - origin_x, block_y - origin_y
  -- Test each rail position for the presence of this block.
  for _, coords in ipairs(blocks_puzzle_rails_positions_to_check) do
    local x2, y2 = coords[1], coords[2]
    local overlaps_x = x1 - 16 < x2 and x2 < x1 + 16
    local overlaps_y = y1 - 16 < y2 and y2 < y1 + 16
    if overlaps_x and overlaps_y then
      return true
    end
  end

  return false
end

for block in map:get_entities("blocks_puzzle_block") do
  block.on_moved = blocks_puzzle_block_moved
  block.is_on_rail = blocks_puzzle_block_is_on_rail
end

-- Moves all blocks of the blocks puzzle in a solved configuration.
function map:set_blocks_puzzle_solved_configuration()

  -- This code was actually generated by the commented function below.
  blocks_puzzle_block_26:set_position(2744, 2333)
  blocks_puzzle_block_12:set_position(2424, 2429)
  blocks_puzzle_block_13:set_position(2456, 2429)
  blocks_puzzle_block_18:set_position(2568, 2333)
  blocks_puzzle_block_31:set_position(2792, 2397)
  blocks_puzzle_block_3:set_position(2392, 2333)
  blocks_puzzle_block_17:set_position(2536, 2349)
  blocks_puzzle_block_36:set_position(2808, 2317)
  blocks_puzzle_block_9:set_position(2392, 2445)
  blocks_puzzle_block_5:set_position(2344, 2365)
  blocks_puzzle_block_27:set_position(2776, 2317)
  blocks_puzzle_block_15:set_position(2488, 2397)
  blocks_puzzle_block_24:set_position(2760, 2317)
  blocks_puzzle_block_23:set_position(2744, 2285)
  blocks_puzzle_block_37:set_position(2824, 2317)
  blocks_puzzle_block_32:set_position(2728, 2381)
  blocks_puzzle_block_1:set_position(2360, 2317)
  blocks_puzzle_block_2:set_position(2376, 2349)
  blocks_puzzle_block_14:set_position(2472, 2397)
  blocks_puzzle_block_33:set_position(2744, 2381)
  blocks_puzzle_block_19:set_position(2552, 2381)
  blocks_puzzle_block_30:set_position(2760, 2413)
  blocks_puzzle_block_4:set_position(2392, 2349)
  blocks_puzzle_block_10:set_position(2424, 2397)
  blocks_puzzle_block_35:set_position(2792, 2317)
  blocks_puzzle_block_11:set_position(2440, 2429)
  blocks_puzzle_block_29:set_position(2792, 2365)
  blocks_puzzle_block_34:set_position(2792, 2381)
  blocks_puzzle_block_28:set_position(2792, 2349)
  blocks_puzzle_block_16:set_position(2536, 2333)
  blocks_puzzle_block_25:set_position(2760, 2301)
  blocks_puzzle_block_8:set_position(2392, 2429)
  blocks_puzzle_block_20:set_position(2552, 2397)
  blocks_puzzle_block_7:set_position(2408, 2397)
  blocks_puzzle_block_6:set_position(2376, 2381)
  blocks_puzzle_block_22:set_position(2712, 2301)
  blocks_puzzle_block_21:set_position(2536, 2429)

  for block in map:get_entities("blocks_puzzle_block") do
    -- Don't allow to move any block again.
    block:set_maximum_moves(0)
  end
end

--[[
-- This debug function was used to generate the code of
-- map:set_blocks_puzzle_solved_configuration() above.
function map:on_key_pressed(key)

  if key == "f8" then
    for block in map:get_entities("blocks_puzzle_block") do
      local x, y = block:get_position()
      print(block:get_name() .. ":set_position(" .. x .. ", " .. y .. ")")
    end
  end
end

function map:on_key_pressed(key)

  if key == "f8" then
    for npc in map:get_entities("tmp_") do
      local x, y = npc:get_position()
      print("{" .. (x - 8) .. ", " .. (y - 13) .. "}")
    end
  end
end
--]]


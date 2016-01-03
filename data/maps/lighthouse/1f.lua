local map = ...

local guard_monster_dead

-- Delete this function when map is done
local function map_temp_dev_init()
  -- Item initialization (for testing purposes)
  local game = map:get_game()
  game:get_item("sword"):set_variant(1)
  game:get_item("shield"):set_variant(1)
  game:get_item("lamp"):set_variant(1)
  game:get_item("magic_bar"):set_variant(1)
  game:get_item("feather"):set_variant(1)
  game:get_item("glove"):set_variant(1)
  game:get_item("bomb_bag"):set_variant(1)
  game:get_item("bombs_counter"):set_variant(1)
  game:get_item("bombs_counter"):set_amount(10)
  game:get_item("bow"):set_variant(1)
  game:get_item("quiver"):set_variant(1)
end

-- Function called on map init
-- Dynamic music initialization
local function map_music_init()
  -- Shutdown wind in music
  sol.audio.set_music_channel_volume(6, 0)
  sol.audio.set_music_channel_volume(7, 0)
end

-- Function called on map init
-- Opens doors when hero comes from another map with stairs
local function locked_doors_in_stairs_init()
  if destination == from_b1_a then
    map:set_doors_open("locked_door_2", true)
  end
  -- Torch puzzle

  if destination == from_2f_c then
    map:set_doors_open("locked_door_6", true)
  end
end

-- Open a specific door with secret sound (puzzle solving)
local function locked_door_open(name)
  map:open_doors(name)
  sol.audio.play_sound("secret")
end

-- Torch puzzle function
local function torch_puzzle()
  local torch_lit_count = 0
  local torch_puzzle_resolved = false

  for torch in map:get_entities("torch_A") do
    torch:get_sprite().on_animation_changed = function(sprite, animation)
      if animation == "lit" then
        torch_lit_count = torch_lit_count + 1
      else
        torch_lit_count = torch_lit_count - 1
      end
      if torch_puzzle_resolved == false and torch_lit_count == 4 then
        map:move_camera(800, 512, 250, function()
          locked_door_open("locked_door_2")
        end)
        torch_puzzle_resolved = true
      end
    end
  end
end

local function boulders_puzzle_init()
  map:set_doors_open("locked_door_4", true)
end

function door_sensor_4:on_activated()
  map:close_doors("locked_door_4")
end

function door_switch_4:on_activated()
  map:open_doors("locked_door_4")
end

-- Pond puzzle init
local function pond_puzzle_init()
  pond_hole:set_visible(false)
  pond_2:set_enabled(false)
  pond_3:set_enabled(false)
  pond_4:set_enabled(false)
  map:set_entities_enabled("pond_stairs", false)
  crystal_switch_water_up:set_activated(true)
end

-- Pond puzzle solving
function crystal_switch_water_down:on_activated()
  sol.audio.play_sound("water_drain")
  sol.timer.start(500, function()
    pond_hole:set_visible(true)
    pond_1:set_enabled(false)
    pond_2:set_enabled(true)
    sol.timer.start(500, function()
      pond_2:set_enabled(false)
      pond_3:set_enabled(true)
      sol.timer.start(500, function()
        pond_3:set_enabled(false)
        pond_4:set_enabled(true)
        sol.timer.start(500, function()
          pond_4:set_enabled(false)
          sol.audio.play_sound("secret")
          crystal_switch_water_up:set_activated(false)
          map:set_entities_enabled("pond_stairs", true)
        end)
      end)
    end)
  end)
end

function crystal_switch_water_up:on_activated()
  sol.audio.play_sound("water_fill")
  sol.timer.start(500, function()
    pond_hole:set_visible(false)
    pond_4:set_enabled(true)
    sol.timer.start(500, function()
      pond_4:set_enabled(false)
      pond_3:set_enabled(true)
      sol.timer.start(500, function()
        pond_3:set_enabled(false)
        pond_2:set_enabled(true)
        sol.timer.start(500, function()
          pond_2:set_enabled(false)
          pond_1:set_enabled(true)
          sol.audio.play_sound("secret")
          crystal_switch_water_down:set_activated(false)
          map:set_entities_enabled("pond_stairs", false)
        end)
      end)
    end)
  end)
end

function door_switch_3:on_activated()
  map:open_doors("locked_door_3")
end

local function guard_puzzle_init()
  for enemy in map:get_entities("guard_monster") do
    enemy.on_dead = guard_monster_dead
  end
end

-- Guard puzzle monsters
function guard_monster_dead(enemy)
  if map:get_entities_count("guard_monster") == 0 then
    sol.audio.play_sound("secret")
    map:open_doors("locked_door_1")
  end
end

local function key_bridge_puzzle_init()
  key_chest_2:set_enabled(false)
end

function chest_switch_2:on_activated()
  sol.audio.play_sound("chest_appears")
  key_chest_2:set_enabled(true)
end

-- Map starting main event function
function map:on_started(destination)
  map_temp_dev_init()
  map_music_init()
  locked_doors_in_stairs_init()
  torch_puzzle()
  boulders_puzzle_init()
  pond_puzzle_init()
  guard_puzzle_init()
  key_bridge_puzzle_init()
end

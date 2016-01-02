local map = ...

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
    map:set_doors_open("LockedDoor2", true)
  end
  -- Torch puzzle
  
  if destination == from_2f_c then
    map:set_doors_open("LockedDoor6", true)
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
          locked_door_open("LockedDoor2")
        end)
        torch_puzzle_resolved = true
      end
    end
  end
end

-- Map starting main event function
function map:on_started(destination)
  map_temp_dev_init()
  map_music_init()
  locked_doors_in_stairs_init()
  torch_puzzle()
end

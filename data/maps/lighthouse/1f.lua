local map = ...

local torch_lit_count = 0
local torch_puzzle_resolved = false

local function locked_door_2_open()
  map:open_doors("LD2")
  sol.audio.play_sound("secret")
end

function map:on_started(destination)
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

  -- Open LD2 door if hero comes from B1 level
  if destination == from_b1_a then
    map:set_doors_open("LD2", true)
  end

  -- Shutdown wind in music
  sol.audio.set_music_channel_volume(6, 0)
  sol.audio.set_music_channel_volume(7, 0)

  -- Torch puzzle
  for torch in map:get_entities("torch_A") do
    torch:get_sprite().on_animation_changed = function(sprite, animation)
      if animation == "lit" then
        torch_lit_count = torch_lit_count + 1
      else
        torch_lit_count = torch_lit_count - 1
      end
      if torch_puzzle_resolved == false and torch_lit_count == 4 then
        map:move_camera(800, 512, 250, locked_door_2_open)
        torch_puzzle_resolved = true
      end
    end
  end
end

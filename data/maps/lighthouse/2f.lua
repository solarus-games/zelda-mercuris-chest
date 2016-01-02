local map = ...
local game = map:get_game()

local compass_monster_dead
local spike_monster_dead

-- Invisible sensor puzzle init
local function invisible_sensor_puzzle_init()
  map:set_doors_open("locked_door_7", true)
end

-- Invisible sensor puzzle activation
function door_sensor_7:on_activated()
  map:close_doors("locked_door_7")
end

-- Tyrolan puzzle init
local function tyrolan_puzzle_init()
  map:set_doors_open("locked_door_8", true)
end

-- Tyrolan puzzle activation
function door_sensor_8:on_activated()
  map:close_doors("locked_door_8")
end

-- Tyrolan puzzle solving
function door_switch_8:on_activated()
  map:open_doors("locked_door_8")
end

-- Compass puzzle init
local function compass_puzzle_init()
  if game:has_dungeon_compass() ~= true then
    compass_chest:set_enabled(false)
    for enemy in map:get_entities("compass_monster") do
      enemy.on_dead = compass_monster_dead
    end
  end
end

-- Compass puzzle monsters
function compass_monster_dead(enemy)
  if map:get_entities_count("compass_monster") == 0 then
    sol.audio.play_sound("chest_appears")
    compass_chest:set_enabled(true)
  end
end

-- Big Key puzzle init
local function big_key_puzzle_init()
  big_key_chest:set_enabled(false)
end

-- Big Key puzzle solving
function big_key_switch:on_activated()
  sol.audio.play_sound("chest_appears")
  big_key_chest:set_enabled(true)
end

-- Speed puzzle init
local function speed_puzzle_init()
  map:set_doors_open("locked_door_9")
end

-- Speed puzzle activation
function door_switch_9:on_activated()
  map:open_doors("locked_door_9")
end

-- Spike monster puzzle init
local function spike_monster_puzzle_init()
  for enemy in map:get_entities("spike_monster") do
    enemy.on_dead = spike_monster_dead
  end
end

-- Spike monster solving
function spike_monster_dead()
  if map:get_entities_count("spike_monster") == 0 then
    sol.audio.play_sound("secret")
    map:open_doors("locked_door_10")
  end
end

-- Torch puzzle init
local function torch_puzzle_init()
  local torch_lit_count = 0
  local torch_puzzle_resolved = false

  if game:get_value("dungeon_3_key_chest_1") ~= true then
    key_chest_1:set_enabled(false)
    for torch in map:get_entities("torch") do
      torch:get_sprite().on_animation_changed = function(sprite, animation)
        if animation == "lit" then
          torch_lit_count = torch_lit_count + 1
        else
          torch_lit_count = torch_lit_count - 1
        end
        if torch_puzzle_resolved == false and torch_lit_count == 2 then
          map:move_camera(224, 624, 250, function()
            sol.audio.play_sound("chest_appears")
            key_chest_1:set_enabled(true)
            game:set_value("dungeon_3_key_chest_1", true)
          end)
          torch_puzzle_resolved = true
        end
      end
    end
  end
end

-- Mini boss init
local function mini_boss_init()

end

-- Map starting main event function
function map:on_started()
  invisible_sensor_puzzle_init()
  tyrolan_puzzle_init()
  compass_puzzle_init()
  big_key_puzzle_init()
  torch_puzzle_init()
end

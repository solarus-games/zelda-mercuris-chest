local map = ...
local game = map:get_game()

local compass_monster_dead

-- Invisible sensor puzzle init
local function invisible_sensor_puzzle_init()
  map:set_doors_open("LockedDoor7", true)
end

-- Invisible sensor puzzle activation
function DoorSensor7:on_activated()
  map:close_doors("LockedDoor7")
end

-- Tyrolan puzzle init
local function tyrolan_puzzle_init()
  map:set_doors_open("LockedDoor8", true)
end

-- Tyrolan puzzle activation
function DoorSensor8:on_activated()
  map:close_doors("LockedDoor8")
end

-- Tyrolan puzzle solving
function DoorSwitch8:on_activated()
  map:open_doors("LockedDoor8")
end

-- Compass puzzle init
local function compass_puzzle_init()
  if game:has_dungeon_compass() ~= true then
    CompassChest:set_visible(false)
    CompassChest:set_enabled(false)
    for enemy in map:get_entities("compass_monster") do
      enemy.on_dead = compass_monster_dead
    end
  end
end

-- Compass puzzle monsters
function compass_monster_dead(enemy)
  if map:get_entities_count("compass_monster") == 0 then
    sol.audio.play_sound("chest_appears")    
    CompassChest:set_visible(true)
    CompassChest:set_enabled(true)
  end
end

-- Big Key puzzle init
local function big_key_puzzle_init()
  BigKeyChest:set_visible(false)
  BigKeyChest:set_enabled(false)
end

-- Big Key puzzle solving
function BigKeySwitch:on_activated()
  sol.audio.play_sound("chest_appears")    
  BigKeyChest:set_visible(true)
  BigKeyChest:set_enabled(true)
end

-- Speed puzzle init
local function speed_puzzle_init()
  map:set_doors_open("LockedDoor9")
end

-- Speed puzzle activation
function DoorSwitch9:on_activated()
  map:open_doors("LockedDoor9")
end

-- Spike monster puzzle init
local function spike_monster_puzzle_init()

end

-- Torch puzzle init
local function torch_puzzle_init()
  KeyChest1:set_visible(true)
  KeyChest1:set_enabled(true)
end

-- Mini boss init
local function mini_boss_init()

end

-- Map starting main event function
function map:on_started()  
  invisible_sensor_puzzle_init()    
  tyrolan_puzzle_init()
  compass_puzzle_init()
  torch_puzzle_init()
end

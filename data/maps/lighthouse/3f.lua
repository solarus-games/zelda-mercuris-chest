-- Lighthouse 3F script

local map = ...
local game = map:get_game()
local statue_eye_puzzle_solved = game:get_value("dungeon_3_statue_eye_activated")
local rpf_builder = require("maps/lib/rotating_platform_builder")

local function statue_eye_puzzle_init()
  if statue_eye_puzzle_solved == true then
    map:set_doors_open("locked_door_13", true)
  end
end

function statue_eye_3:on_activated()
  if statue_eye_puzzle_solved ~= true then
    map:open_doors("locked_door_13")
    sol.audio.play_sound("secret")
    game:set_value("dungeon_3_statue_eye_activated", true)
  end
end

function map:on_started()
  statue_eye_puzzle_init()
  local rpf1 = rpf_builder:create(map, "rpf1")
end

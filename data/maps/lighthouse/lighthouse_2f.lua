local map = ...

function map:on_started()
  map:set_doors_open("LD6", true)
  map:set_doors_open("LD7", true)
  CC:set_enabled(false)
end

function DS6:on_activated()
  map:close_doors("LD6")
end

function DS7:on_activated()
  map:close_doors("LD7")
end

function DS8:on_activated()
  map:open_doors("LD7")
  map:open_doors("LD8")
end

-- Compass puzzle
function compass_enemy_dead(enemy)
  if map:get_entities_count("compass_enemy") == 0 then
    sol.audio.play_sound("chest_appears")    
    CC:set_enabled(true)
  end
end
for enemy in map:get_entities("compass_enemy") do
  enemy.on_dead = compass_enemy_dead
end

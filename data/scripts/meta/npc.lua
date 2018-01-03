-- Provides additional features to the npc type for this quest.

require("scripts/multi_events")

local npc_meta = sol.main.get_metatable("npc")

npc_meta:register_event("on_created", function(npc)

  local name = npc:get_name()
  if name == nil then
    return
  end

  if name:match("^random_walk_npc") then
    npc:random_walk()
  end
end)

-- Makes the NPC randomly walk with the given optional speed.
function npc_meta:random_walk(speed)

  local movement = sol.movement.create("random_path")

  if speed ~= nil then
    movement:set_speed(speed)
  end

  movement:start(self)
end

return true

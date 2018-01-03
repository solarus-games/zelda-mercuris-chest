-- Provides additional features to the dynamic tile type for this quest.

require("scripts/multi_events")

local dynamic_tile_meta = sol.main.get_metatable("dynamic_tile")

dynamic_tile_meta:register_event("on_created", function(dynamic_tile)

  local name = dynamic_tile:get_name()
  if name == nil then
    return
  end

  if name:match("^invisible_tile") then
    dynamic_tile:set_visible(false)
  end
end)

return true

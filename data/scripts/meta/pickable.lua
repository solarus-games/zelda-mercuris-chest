-- Provides additional features to the pickable type for this quest.

require("scripts/multi_events")

local pickable_meta = sol.main.get_metatable("pickable")

pickable_meta:register_event("on_created", function(pickable)

  local name = pickable:get_name()
  if name == nil then
    return
  end

  if name:match("^lens_invisible_pickable") then
    pickable:set_visible(false)
    sol.timer.start(pickable, 10, function()
      local lens = pickable:get_game():get_item("lens_of_truth")
      lens:update_invisible_entity(pickable)
      return true
    end)
  end

end)

return true

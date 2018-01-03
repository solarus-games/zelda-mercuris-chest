-- Provides additional features to the switch type for this quest.

require("scripts/multi_events")

local switch_meta = sol.main.get_metatable("switch")

switch_meta:register_event("on_activated", function(switch)

  local name = switch:get_name()

  if name == nil then
    return
  end

  -- Switches named "lever_switch*" are re-activable and have two
  -- alternative visuals.
  if name:match("^lever_switch") then
    local sprite = switch:get_sprite()
    local direction = sprite:get_direction()
    sprite:set_direction(1 - direction)  -- Direction may be 0 or 1.

    -- Allow to activate it again.
    sol.timer.start(switch, 1000, function()
      switch:set_activated(false)
    end)
  end

end)

return true

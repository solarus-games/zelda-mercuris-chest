-- Provides additional features to the destructible type for this quest.
-- Shows a dialog when the player cannot lift them.

require("scripts/multi_events")

local destructible_meta = sol.main.get_metatable("destructible")

destructible_meta:register_event("on_looked", function(destructible)

  local game = destructible:get_game()
  if destructible:get_can_be_cut()
      and not destructible:get_can_explode()
      and not game:has_ability("sword") then
    -- The destructible can be cut, but the player no cut ability.
    game:start_dialog("_cannot_lift_should_cut");
  elseif not game:has_ability("lift") then
    -- No lift ability at all.
    game:start_dialog("_cannot_lift_too_heavy");
  else
    -- Not enough lift ability.
    game:start_dialog("_cannot_lift_still_too_heavy");
  end

end)

return true

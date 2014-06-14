-- A minecart to be used by the hero on railroads.

local minecart = ...

minecart:create_sprite("entities/minecart")
minecart:set_traversable_by("hero", false)

function minecart:on_interaction()

  hero:freeze()
  hero:set_animation("minecart_driving")
  minecart:get_sprite():set_animation("driving")
end


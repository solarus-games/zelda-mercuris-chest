local enemy = ...

-- Vipeross.

require("enemies/generic_towards_hero")(enemy)

enemy:set_properties({
  sprite = "enemies/" .. enemy:get_breed(),
  life = 8,
  damage = 4,
  normal_speed = 48,
  faster_speed = 48
})

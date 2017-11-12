local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 14,
  damage = 6,
  normal_speed = 48,
  faster_speed = 48
}

behavior:create(enemy, properties)

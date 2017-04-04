local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 20,
  damage = 4,
  normal_speed = 48,
  faster_speed = 48
}

behavior:create(enemy, properties)

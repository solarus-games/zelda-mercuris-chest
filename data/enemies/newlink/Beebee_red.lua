local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 28,
  damage = 8,
  normal_speed = 52,
  faster_speed = 52
}

behavior:create(enemy, properties)
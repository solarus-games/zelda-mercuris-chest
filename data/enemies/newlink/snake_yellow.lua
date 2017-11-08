local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 4,
  damage = 6,
  normal_speed = 36,
  faster_speed = 36
}

behavior:create(enemy, properties)

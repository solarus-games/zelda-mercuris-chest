local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 8,
  damage = 8,
  normal_speed = 40,
  faster_speed = 48
}

behavior:create(enemy, properties)
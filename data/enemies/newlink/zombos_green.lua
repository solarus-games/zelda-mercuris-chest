local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 10,
  damage = 10,
  normal_speed = 40,
  faster_speed = 48
}

behavior:create(enemy, properties)
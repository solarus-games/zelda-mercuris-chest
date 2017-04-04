-- Allow to control the hero with a virtual joystick and 5 virtual buttons triggered by touch events.

-- Usage:
-- require("scripts/touch_layer")

local buttons = {
  item_1 = {
    surface = sol.surface.create("touch/icons/item_1.png"),
    x = 232,
    y = 225,
    key = "x",
  },
  pause = {
    surface = sol.surface.create("touch/icons/pause.png"),
    x = 250,
    y = 200,
    key = "d",
  },
  item_2 = {
    surface = sol.surface.create("touch/icons/item_2.png"),
    x = 268,
    y = 225,
    key = "v",
  },
  action = {
    surface = sol.surface.create("touch/icons/action.png"),
    x = 286,
    y = 200,
    key = "space",
  },
  attack = {
    surface = sol.surface.create("touch/icons/attack.png"),
    x = 304,
    y = 225,
    key = "c",
  },
}

local joystick = {
  background_surface = sol.surface.create("touch/joystick/background.png"),
  stick_surface = sol.surface.create("touch/joystick/stick.png"),
  x = 35,
  y = 205
}


-- Initialize virtual commands.
for _, button in pairs(buttons) do
  button.surface:set_opacity(90)
  button.menu = require("scripts/menus/virtual_button").create(button)
end

joystick.background_surface:set_opacity(90)
joystick.stick_surface:set_opacity(90)
joystick.menu = require("scripts/menus/virtual_joystick").create(joystick)

return true

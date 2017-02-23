-- Allow to control the hero with a virtual joystick and 5 virtual buttons triggered by touch events.

-- Usage:
-- require("scripts/touch_layer.lua")
-- touch_layer:set_callback_context(context)

-- Then the script will call the context:on_virtual_command_event(command, is_pressed)
-- event each time a virtual command is pressed or released.

local touch_layer = {}

local buttons = {
    item_1 = {
        surface = sol.surface.create("touch/icons/item_1.png"),
        x = 232,
        y = 225,
        command = "item_1",
    },
    pause = {
        surface = sol.surface.create("touch/icons/pause.png"),
        x = 250,
        y = 200,
        command = "pause",
    },
    item_2 = {
        surface = sol.surface.create("touch/icons/item_2.png"),
        x = 268,
        y = 225,
        command = "item_2",
    },
    action = {
        surface = sol.surface.create("touch/icons/action.png"),
        x = 286,
        y = 200,
        command = "action",
    },
    attack = {
        surface = sol.surface.create("touch/icons/attack.png"),
        x = 304,
        y = 225,
        command = "attack",
    },
}

local joystick = {
  background_surface = sol.surface.create("touch/joystick/background.png"),
  stick_surface = sol.surface.create("touch/joystick/stick.png"),
  x = 35,
  y = 205
}


function touch_layer:start(context)

  if sol.main.get_os() == "iOS" then
    local virtual_buttons = require("scripts/menus/virtual_button")
    for _, button in pairs(buttons) do
      button.surface:set_opacity(90)
      button.menu = virtual_buttons.create(button)
      sol.menu.start(context, button.menu)
    end

	joystick.background_surface:set_opacity(90)
	joystick.stick_surface:set_opacity(90)
    joystick.menu = require("scripts/menus/virtual_joystick")
    sol.menu.start(context, joystick.menu)
    joystick.menu:create(joystick)
  end
end

function touch_layer:set_callback_context(callback_context)

  if sol.main.get_os() == "iOS" then
    for _, button in pairs(buttons) do
      button.menu:set_callback_context(callback_context)
    end
    joystick.menu:set_callback_context(callback_context)
  end
end

function touch_layer:set_game(game)

  if sol.main.get_os() == "iOS" then
    self.game = game
    for _, button in pairs(buttons) do
      button.menu:set_callback_context(self)
    end
    joystick.menu:set_callback_context(self)
  end
end

-- Make this function as callback once a game is started
function touch_layer:on_virtual_command_event(command, is_pressed)

  if is_pressed then
    self.game:simulate_command_pressed(command)
  else
    self.game:simulate_command_released(command)
  end
end

return touch_layer

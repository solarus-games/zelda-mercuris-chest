-- Touchable virtual button.
-- The create(icon) function can create several virtual buttons for a same quest.

-- Usage:
-- local button_menu = require("scripts/menus/virtual_button").create(icon)

local virtual_button = {}
virtual_button.__index = virtual_button

function virtual_button:on_finger_pressed(finger, x, y)

  -- If the mouse position is over a button, simulate the corresponding command.
  if sol.main.get_distance(x, y, self.x, self.y) < self.icon_width / 2 then
    self:start_command()
  end
end

function virtual_button:on_finger_released(finger, x, y)

  self:stop_command()
end

function virtual_button:on_draw(screen)

  self.surface:draw(screen, self.x - self.icon_width / 2, self.y - self.icon_height / 2)
end

function virtual_button:start_command()

  if not self.is_pushed then
    self.is_pushed = true
    sol.input.simulate_key_pressed(self.key)
  end
end

function virtual_button:stop_command()

  if self.is_pushed then
    self.is_pushed = false
    sol.input.simulate_key_released(self.key)
  end
end

-- Create and return an instance of a virtual button menu.
function virtual_button.create(icon)

	local mt = {}
	setmetatable(mt, virtual_button)
	mt.surface = icon.surface
	mt.x = icon.x
	mt.y = icon.y
	mt.key = icon.key

	mt.is_pushed = false
	mt.icon_width, mt.icon_height = icon.surface:get_size()

	sol.menu.start(sol.main, mt)

	return mt
end

return virtual_button

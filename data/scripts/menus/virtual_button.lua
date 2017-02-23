-- Touchable virtual button.
local virtual_button = {}
virtual_button.__index = virtual_button

function virtual_button.create(icon)

  local mt = {}
  setmetatable(mt, virtual_button)
  mt.surface = icon.surface
  mt.x = icon.x
  mt.y = icon.y
  mt.command = icon.command

  mt.callback_context = nil
  mt.is_pushed = false
  mt.icon_width, mt.icon_height = icon.surface:get_size()

  return mt
end

function virtual_button:set_callback_context(callback_context)

  self.callback_context = callback_context
end

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
    if self.callback_context ~= nil then
      self.callback_context:on_virtual_command_event(self.command, true)
    end
  end
end

function virtual_button:stop_command()

  if self.is_pushed then
    self.is_pushed = false
    if self.callback_context ~= nil then
      self.callback_context:on_virtual_command_event(self.command, false)
    end
  end
end

return virtual_button

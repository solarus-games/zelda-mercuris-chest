-- Touchable virtual joystick.
-- Assume that the virtual joystick is a circle.
local virtual_joystick = {}

local simulated_directions = {
  right = false,
  up = false,
  left = false,
  down = false
}

local callback_context = nil
local pressed_finger = nil
local angle = 0
local background_icon_half_width, background_icon_half_height
local stick_icon_half_width, stick_icon_half_height

function virtual_joystick:create(icon)

  self.background_surface = icon.background_surface
  self.stick_surface = icon.stick_surface
  self.center_x = icon.x
  self.center_y = icon.y
  
  background_icon_half_width, background_icon_half_height = self.background_surface:get_size()
  stick_icon_half_width, stick_icon_half_height = self.stick_surface:get_size()
  background_icon_half_width = background_icon_half_width / 2
  background_icon_half_height = background_icon_half_height / 2
  stick_icon_half_width = stick_icon_half_width / 2
  stick_icon_half_height = stick_icon_half_height / 2
end

function virtual_joystick:set_callback_context(new_callback_context)

  callback_context = new_callback_context
end

function virtual_joystick:on_finger_pressed(finger, x, y, pressure)

  -- If the finger position is near enough to the joystick, simulate corresponding directions.
  if pressed_finger == nil and sol.main.get_distance(x, y, self.center_x, self.center_y) < background_icon_half_width * 2 then
    pressed_finger = finger
    self:update_directions(x, y)
  end
end

function virtual_joystick:on_finger_moved(finger, x, y, dx, dy, pressure)

  -- If the finger that pressed the joystick before is moved, update simulated directions.
  if finger == pressed_finger then
    self:update_directions(x, y)
  end
end

function virtual_joystick:on_finger_released(finger, x, y, pressure)

  -- If the finger that pressed the joystick before is released, stop all directions.
  if finger == pressed_finger then
    pressed_finger = nil
    for direction, _ in pairs(simulated_directions) do
      self:stop_direction(direction)
    end
  end
end

function virtual_joystick:on_draw(screen)

  -- Compute the position to display the joystick and its background.
  local stick_icon_x = self.center_x - stick_icon_half_width
  local stick_icon_y = self.center_y - stick_icon_half_height

  if pressed_finger ~= nil then
    stick_icon_x = stick_icon_x + stick_icon_half_width * math.cos(angle) / 2
    stick_icon_y = stick_icon_y - stick_icon_half_height * math.sin(angle) / 2
  end

  -- Display the background and the joystick.
  self.background_surface:draw(screen, self.center_x - background_icon_half_width, self.center_y - background_icon_half_height)
  self.stick_surface:draw(screen, stick_icon_x, stick_icon_y)
end

function virtual_joystick:update_directions(finger_x, finger_y)

  -- Check the position of the finger and simulate appropriate directions.
  local circle_fraction = math.pi / 8
  angle = sol.main.get_angle(self.center_x, self.center_y, finger_x, finger_y)

  self:update_direction("right", angle < 3 * circle_fraction or angle > 13 * circle_fraction)
  self:update_direction("up", angle > circle_fraction and angle < 7 * circle_fraction)
  self:update_direction("left", angle > 5 * circle_fraction and angle < 11 * circle_fraction)
  self:update_direction("down", angle > 9 * circle_fraction and angle < 15 * circle_fraction)
end

function virtual_joystick:update_direction(direction, is_movement_needed)

  if is_movement_needed then
    self:start_direction(direction)
  else
    self:stop_direction(direction)
  end
end

function virtual_joystick:start_direction(direction)

  if not simulated_directions[direction] then
    simulated_directions[direction] = true
    if callback_context ~= nil and self.callback_context.on_virtual_command_pressed ~= nil then
      callback_context:on_virtual_command_pressed(direction)
    end
  end
end

function virtual_joystick:stop_direction(direction)

  if simulated_directions[direction] then
    simulated_directions[direction] = false
    if callback_context ~= nil and self.callback_context.on_virtual_command_released ~= nil then
      callback_context:on_virtual_command_released(direction)
    end
  end
end

return virtual_joystick

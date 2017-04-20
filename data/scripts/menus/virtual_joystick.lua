-- Touchable virtual joystick.
-- The create(icon) function should be called only once, there can only be one virtual joystick by quest.

-- Usage:
-- require("scripts/menus/virtual_joystick").create(icon)

local virtual_joystick = {}

local simulated_directions = {
  right = false,
  up = false,
  left = false,
  down = false
}

local deadzone_ratio = 3
local pressed_finger = nil
local angle = 0
local distance_finger_to_center = 0
local deadzone_ray = 0
local half_sizes = {}

function virtual_joystick:on_finger_pressed(finger, x, y, pressure)

  -- If the finger position is near enough to the joystick, simulate corresponding directions.
  distance_finger_to_center = sol.main.get_distance(x, y, self.center_x, self.center_y)
  if pressed_finger == nil and distance_finger_to_center < half_sizes.background_width * 2 then
    pressed_finger = finger
    if distance_finger_to_center > deadzone_ray then
      self:update_directions(x, y)
    end
  end
end

function virtual_joystick:on_finger_moved(finger, x, y, dx, dy, pressure)

  -- If the finger that pressed the joystick before is moved, update simulated directions.
  if finger == pressed_finger then
    distance_finger_to_center = sol.main.get_distance(x, y, self.center_x, self.center_y)
    if distance_finger_to_center > deadzone_ray then
      self:update_directions(x, y)
    else
      for direction, _ in pairs(simulated_directions) do
        self:stop_direction(direction)
      end
    end
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
  local stick_icon_x = self.center_x - half_sizes.stick_width
  local stick_icon_y = self.center_y - half_sizes.stick_height

  if pressed_finger ~= nil and distance_finger_to_center > deadzone_ray then
    stick_icon_x = stick_icon_x + half_sizes.stick_width * math.cos(angle) / 2
    stick_icon_y = stick_icon_y - half_sizes.stick_height * math.sin(angle) / 2
  end

  -- Display the background and the joystick.
  self.background_surface:draw(screen, self.center_x - half_sizes.background_width, self.center_y - half_sizes.background_height)
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
    sol.input.simulate_key_pressed(direction)
  end
end

function virtual_joystick:stop_direction(direction)

  if simulated_directions[direction] then
    simulated_directions[direction] = false
    sol.input.simulate_key_released(direction)
  end
end


-- Create and return the virtual joystick menu.
function virtual_joystick.create(icon)

  virtual_joystick.background_surface = icon.background_surface
  virtual_joystick.stick_surface = icon.stick_surface
  virtual_joystick.center_x = icon.x
  virtual_joystick.center_y = icon.y

  half_sizes.background_width, half_sizes.background_height = virtual_joystick.background_surface:get_size()
  half_sizes.stick_width, half_sizes.stick_height = virtual_joystick.stick_surface:get_size()
  for half_size, _ in pairs(half_sizes) do
    half_sizes[half_size] = half_sizes[half_size] / 2
  end
  deadzone_ray = half_sizes.background_width / deadzone_ratio

  sol.menu.start(sol.main, virtual_joystick)
end

return virtual_joystick

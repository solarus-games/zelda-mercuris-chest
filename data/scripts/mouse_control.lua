-- Allows to control the hero with the mouse.

-- Usage:
-- require("scripts/mouse_control")

require("scripts/multi_events")

local deadzone_ray = 10 -- Should be set to the max number of pixel that the hero can move in one frame.

local function initialize_mouse_control_features(game)

  local mouse_control = {}

  local is_mouse_button_pushed = false

  -- Movement of the hero.
  local directions_pressed = {
      right = false,
      up = false,
      left = false,
      down = false
  }

  function mouse_control:on_mouse_pressed(button, x, y)

    is_mouse_button_pushed = true
  end

  function mouse_control:on_mouse_released(button, x, y)

    is_mouse_button_pushed = false
  end

  function mouse_control:on_update()

    local map = game:get_map()
    if map == nil then
      return
    end

    if is_mouse_button_pushed then

      local camera = map:get_camera()
      local hero_x, hero_y = map:get_hero():get_position()
      local camera_x, camera_y = camera:get_position()
      local mouse_x, mouse_y = sol.input.get_mouse_position()
      mouse_x = mouse_x + camera_x
      mouse_y = mouse_y + camera_y

      -- Compare the position of the hero and the mouse
      -- and simulate the appropriate command for each directions.
      self:update_direction("right", mouse_x > hero_x + deadzone_ray)
      self:update_direction("up", mouse_y < hero_y - deadzone_ray)
      self:update_direction("left", mouse_x < hero_x - deadzone_ray)
      self:update_direction("down", mouse_y > hero_y + deadzone_ray)
    else

      for direction, _ in pairs(directions_pressed) do
        self:stop_direction(direction)
      end
    end
  end

  function mouse_control:update_direction(direction, is_movement_needed)

    if is_movement_needed then
      self:start_direction(direction)
    else
      self:stop_direction(direction)
    end
  end

  function mouse_control:start_direction(direction)

    if not directions_pressed[direction] then
      directions_pressed[direction] = true
      game:simulate_command_pressed(direction)
    end
  end

  function mouse_control:stop_direction(direction)

    if directions_pressed[direction] then
      directions_pressed[direction] = false
      game:simulate_command_released(direction)
    end
  end

  local on_top = false  -- Keep the HUD above in case there are clickable HUD buttons.
  sol.menu.start(game, mouse_control, on_top)
end

-- Set up the mouse control features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_mouse_control_features)
return true

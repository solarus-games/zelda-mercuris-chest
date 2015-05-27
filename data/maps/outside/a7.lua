local map = ...
local game = map:get_game()

local overlay_angles = {
  3 * math.pi / 4,
  5 * math.pi / 4,
      math.pi / 4,
  7 * math.pi / 4
}
local overlay_step = 1
local overlay
local overlay_movement

local function restart_overlay_movement()

  overlay_movement:set_speed(16)
  overlay_movement:set_max_distance(100)
  overlay_movement:set_angle(overlay_angles[overlay_step])
  overlay_step = overlay_step + 1
  if overlay_step > #overlay_angles then
    overlay_step = 1
  end
  overlay_movement:start(overlay, restart_overlay_movement)
end

local function initialize_overlay()

  overlay = sol.surface.create("entities/overlay_forest_leaves.png")
  overlay:set_opacity(64)
  overlay_offset_x = 0  -- Used to keep continuity when getting lost.
  overlay_offset_y = 0
  overlay_movement = sol.movement.create("straight")
  restart_overlay_movement()

end

function map:on_started()

  initialize_overlay()
end

function map:on_draw(dst_surface)

  -- Make the overlay scroll with the camera, but slightly faster to make
  -- a depth effect.
  local camera_x, camera_y = map:get_camera_position()
  local overlay_width, overlay_height = overlay:get_size()
  local screen_width, screen_height = dst_surface:get_size()
  local x, y = camera_x + overlay_offset_x, camera_y + overlay_offset_y
  x, y = -math.floor(x * 1.5), -math.floor(y * 1.5)

  -- The overlay's image may be shorter than the screen, so we repeat its
  -- pattern. Furthermore, it also has a movement so let's make sure it
  -- will always fill the whole screen.
  x = x % overlay_width - 2 * overlay_width
  y = y % overlay_height - 2 * overlay_height

  local dst_y = y
  while dst_y < screen_height + overlay_height do
    local dst_x = x
    while dst_x < screen_width + overlay_width do
      -- Repeat the overlay's pattern.
      overlay:draw(dst_surface, dst_x, dst_y)
      dst_x = dst_x + overlay_width
    end
    dst_y = dst_y + overlay_height
  end

end

local map = ...

function map:on_started()
  local platform_movement = sol.movement.create("straight")  
  platform_movement:set_speed(32)
  platform_movement:set_angle(math.pi)
  platform_movement:set_ignore_obstacles(true)
  platform_movement:set_max_distance(48)
  platform_movement:start(moving_platform)

  platform_movement.on_finished = function()
    local platform_movement = sol.movement.create("straight")
    platform_movement:set_speed(32)
    platform_movement:set_angle(platform_movement:get_angle())
    platform_movement:set_ignore_obstacles(true)
    platform_movement:set_max_distance(48)
    platform_movement:start(moving_platform)


    platform_movement:set_angle(platform_movement:get_angle() + math.pi)
    platform_movement:start(moving_platform)
  end
end

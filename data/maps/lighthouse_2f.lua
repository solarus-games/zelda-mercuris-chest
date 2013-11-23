local map = ...

function map:on_started()
  local platform_movement = sol.movement.create("straight")  
  platform_movement:set_angle(math.pi)
  platform_movement:start(moving_platform)
  
  moving_platform.on_obstacle_reached = function(movement)
    if movement:get_angle() == math.pi then
      movement:set_angle(0)
    else
      movement:set_angle(math.pi)
    end
  end
end

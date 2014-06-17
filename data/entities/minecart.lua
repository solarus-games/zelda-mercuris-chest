-- A minecart to be used by the hero on railroads.

local minecart = ...

minecart:create_sprite("entities/minecart")

-- Don't let the hero traverse the minecart.
minecart:set_traversable_by("hero", false)

-- Hurt enemies hit by the minecart.
minecart:add_collision_test("sprite", function(minecart, other)

  if other:get_type() == "enemy" then
    other:hurt(8)
  end
end)

-- Detect minecart turns.
minecart:add_collision_test("containing", function(minecart, other)

  if other:get_type() == "custom_entity" then
    if other:get_model() == "minecart_turn" then
      local hero = minecart:get_map():get_hero()
      local movement = hero:get_movement()
      if movement ~= nil then
        -- Simply change the hero's movement direction.
        local direction4 = other:get_direction()
        movement:set_angle(direction4 * math.pi / 2)
      end
    end
  end
end)

-- Called when the hero presses the action command near the minecart.
function minecart:on_interaction()

  if minecart:get_sprite():get_animation() == "stopped" then
    minecart:go()
  end
end

-- Starts driving the minecart.
function minecart:go()

  local hero = minecart:get_map():get_hero()
  hero:freeze()
  hero:set_position(minecart:get_position())
  hero:set_animation("minecart_driving")
  minecart:get_sprite():set_animation("driving")

  -- Create a movement on the hero.
  local direction4 = minecart:get_direction()
  local movement = sol.movement.create("straight")
  movement:set_angle(direction4 * math.pi / 2)
  movement:set_speed(96)

  function movement:on_position_changed()
    -- Put the minecart at the same position as the hero.
    minecart:set_position(hero:get_position())
  end

  -- Destroy the minecart when reaching an obstacle.
  function movement:on_obstacle_reached()
    minecart:stop()
  end

  -- The hero must be allowed to traverse the minecart during the movement.
  minecart:set_traversable_by("hero", true)

  movement:start(hero)
end

-- Stops driving the minecart and destroys it.
function minecart:stop()

  local hero = minecart:get_map():get_hero()
  local minecart_sprite = minecart:get_sprite()

  -- Break the minecart.
  sol.audio.play_sound("stone")
  minecart_sprite:set_animation("breaking")

  function minecart_sprite:on_animation_finished()
    -- Remove it from the map when the animation is finished.
    minecart:remove()
  end

  -- Restore control to the player.
  hero:unfreeze()
end


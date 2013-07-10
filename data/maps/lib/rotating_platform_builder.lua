-- Rotating platform script
-- Version 0.1.1

local rotating_platform_builder = {}

function rotating_platform_builder:create(map, prefix)
  local platform = {
    map = map,
    prefix = prefix,
  }
  local sensors = {
    ["top"] = map:get_entity(prefix .. "_sensor_top")
    ["left"] = map:get_entity(prefix .. "_sensor_left")
    ["right"] = map:get_entity(prefix .. "_sensor_right")
    ["bottom"] = map:get_entity(prefix .. "_sensor_bottom")
  }
  local barrier = prefix .. "_barrier"
  local current_state = game:get_value(prefix .. "_save_state")
  
  for _, sensor in ipairs(sensors) do
    sensor.on_activated = sensor_activated
  end
  
  --
  function platform:get_state()
    return current_state
  end
  
  --
  function platform:set_state(state)
    if state == "blue" or state == "orange" then
      current_state = state
    end
  end
  
  --
  function platform:toggle_state()
    if current_state == "blue" then
      platform:set_state("orange")
    else
      platform:set_state("blue")
    end
  end
  
  -- Rotates the platform when the hero enters it
  -- A sound is produced and the platform has a rotating animation
  function platform:rotate()
    sol.audio.play_sound("rotating_platform")
    platform:toggle_state()
  end
  
  -- 
  local function sensor_activated(sensor)
    
  end
  
  return platform
end

return rotating_platform_builder

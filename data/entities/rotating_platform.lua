
local platform = ...

local map = platform:get_map()
local sprite = platform:get_sprite()
local hero = map:get_hero()
local platform_name = platform:get_name()
local platform_x, platform_y, platform_layer = platform:get_position()

local directions = {}
directions["right"] = 0
directions["upright"] = math.pi / 4
directions["up"] = math.pi / 2
directions["upleft"] = 3 * math.pi / 4
directions["left"] = math.pi
directions["downleft"] = 5 * math.pi / 4
directions["down"] = 3 * math.pi / 2
directions["downright"] = 7 * math.pi / 4

local movements = {}
movements["blue"] = {}
movements["blue"]["down"] = {"upright", "right"}
movements["blue"]["right"] = {"upleft", "up"}
movements["blue"]["up"] = {"downleft", "left"}
movements["blue"]["left"] = {"downright", "down"}
movements["red"] = {}
movements["red"]["down"] = {"upleft", "left"}
movements["red"]["right"] = {"downleft", "down"}
movements["red"]["up"] = {"downright", "right"}
movements["red"]["left"] = {"upright", "up"}

local hero_directions = {}
hero_directions["blue"] = {}
hero_directions["blue"]["down"] = 0
hero_directions["blue"]["right"] = 1
hero_directions["blue"]["up"] = 2
hero_directions["blue"]["left"] = 3
hero_directions["red"] = {}
hero_directions["red"]["down"] = 2
hero_directions["red"]["right"] = 3
hero_directions["red"]["up"] = 0
hero_directions["red"]["left"] = 1

local sensor_up = map:create_sensor({
  name = platform_name .. "_sensor_up",
  width = 16,
  height = 16,
  layer = platform_layer,
  x = platform_x + 16,
  y = platform_y
})

local sensor_left = map:create_sensor({
  name = platform_name .. "_sensor_left",
  width = 16,
  height = 16,
  layer = platform_layer,
  x = platform_x,
  y = platform_y + 16
})

local sensor_right = map:create_sensor({
  name = platform_name .. "_sensor_right",
  width = 16,
  height = 16,
  layer = platform_layer,
  x = platform_x + 32,
  y = platform_y + 16
})

local sensor_down = map:create_sensor({
  name = platform_name .. "_sensor_down",
  width = 16,
  height = 16,
  layer = platform_layer,
  x = platform_x + 16,
  y = platform_y + 32
})

function platform:set_state(state)
  if state == "red" then
    sprite:set_animation("red_stopped")
  else
    sprite:set_animation("blue_stopped")
  end
end

function platform:get_state()
  if sprite:get_animation() == "red_stopped" then
    return "red"
  else
    return "blue"
  end
end

local function enable_all_sensors()
  sensor_up:set_enabled(true)
  sensor_left:set_enabled(true)
  sensor_right:set_enabled(true)
  sensor_down:set_enabled(true)
end

local function disable_all_sensors()
  sensor_up:set_enabled(false)
  sensor_left:set_enabled(false)
  sensor_right:set_enabled(false)
  sensor_down:set_enabled(false)
end

local function get_sensor_suffix(sensor)
  local name = sensor:get_name()
  k = 1
  t = {}
  for v in string.gmatch(name, "([^_]+)") do
    t[k] = v
    k = k + 1
  end
  return t[#t]
end

local function rotate_platform()
  sol.audio.play_sound("enemy_awake")
  if platform:get_state() == "red" then
    sprite:set_animation("red_rotating", function()
      sprite:set_animation("blue_stopped")
    end)
  else
    sprite:set_animation("blue_rotating", function()
      sprite:set_animation("red_stopped")
    end)
  end
end

local function move_hero(sensor)
  local platform_state = platform:get_state()  
  local sensor_suffix = get_sensor_suffix(sensor)
  local movement_suite = movements[platform_state][sensor_suffix]
  local diagonal_movement = sol.movement.create("straight")
  hero:set_direction(hero_directions[platform_state][sensor_suffix])
  hero:set_animation("walking")
  diagonal_movement:set_ignore_obstacles(true)
  diagonal_movement:set_max_distance(20)
  diagonal_movement:set_angle(directions[movement_suite[1]])
  diagonal_movement:set_speed(128)
  diagonal_movement:start(hero, function()
    local exit_movement = sol.movement.create("straight")    
    exit_movement:set_max_distance(20)
    exit_movement:set_angle(directions[movement_suite[2]])    
    exit_movement:set_speed(128)
    exit_movement:start(hero, function()
      sol.audio.play_sound("arrow_hit")
      hero:unfreeze()
      enable_all_sensors()
    end)
  end)
end

local function sensor_on_activated(sensor)
  hero:freeze()
  disable_all_sensors()
  move_hero(sensor)
  rotate_platform()
end

sensor_up.on_activated = sensor_on_activated
sensor_left.on_activated = sensor_on_activated
sensor_right.on_activated = sensor_on_activated
sensor_down.on_activated = sensor_on_activated

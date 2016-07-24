-- This script handles global behavior of this quest,
-- that is, things not related to a particular savegame.
local quest_manager = {}

-- Initialize map features specific to this quest.
local function initialize_map()

  local map_meta = sol.main.get_metatable("map")

  function map_meta:move_camera(x, y, speed, callback, delay_before, delay_after)

    local camera = self:get_camera()
    local game = self:get_game()
    local hero = self:get_hero()

    delay_before = delay_before or 1000
    delay_after = delay_after or 1000

    local old_x, old_y = camera:get_position()
    game:set_suspended(true)
    camera:start_manual()

    local movement = sol.movement.create("target")
    movement:set_target(camera:get_position_to_track(x, y))
    movement:set_ignore_obstacles(true)
    movement:set_speed(speed)
    movement:start(camera, function()
      local timer_1 = sol.timer.start(self, delay_before, function()
        if callback ~= nil then
          callback()
        end
        local timer_2 = sol.timer.start(self, delay_after, function()
          local movement = sol.movement.create("target")
          movement:set_target(old_x, old_y)
          movement:set_ignore_obstacles(true)
          movement:set_speed(speed)
          movement:start(camera, function()
            game:set_suspended(false)
            camera:start_tracking(hero)
            if self.on_camera_back ~= nil then
              self:on_camera_back()
            end
          end)
        end)
        timer_2:set_suspended_with_map(false)
      end)
      timer_1:set_suspended_with_map(false)
    end)
  end
end

-- Initializes the common behavior of destructible objects.
local function initialize_destructible()

  -- Destructibles: show a dialog when the player cannot lift them.
  local destructible_meta = sol.main.get_metatable("destructible")
  -- destructible_meta represents the shared behavior of all destructible objects.

  function destructible_meta:on_looked()

    -- Here, self is the destructible object.
    local game = self:get_game()
    if self:get_can_be_cut()
        and not self:get_can_explode()
        and not self:get_game():has_ability("sword") then
      -- The destructible can be cut, but the player no cut ability.
      game:start_dialog("_cannot_lift_should_cut");
    elseif not game:has_ability("lift") then
      -- No lift ability at all.
      game:start_dialog("_cannot_lift_too_heavy");
    else
      -- Not enough lift ability.
      game:start_dialog("_cannot_lift_still_too_heavy");
    end
  end
end

-- Initialize enemy behavior specific to this quest.
local function initialize_enemy()

  local enemy_meta = sol.main.get_metatable("enemy")

  -- Add cane of Medusa properties to enemies.
  local enemy_meta = sol.main.get_metatable("enemy")
  enemy_meta.vulnerable_to_medusa = true  -- Vulnerable by default.
  function enemy_meta:is_vulnerable_to_medusa()
    return self.vulnerable_to_medusa
  end

  function enemy_meta:set_vulnerable_to_medusa(vulnerable)
    self.vulnerable_to_medusa = vulnerable
  end

  local built_in_set_invincible = enemy_meta.set_invincible
  assert(type(built_in_set_invincible) == "function")
  function enemy_meta:set_invincible()
    built_in_set_invincible(self)
    self:set_vulnerable_to_medusa(false)
  end

end

-- Initialize sensor behavior specific to this quest.
local function initialize_sensor()

  local sensor_meta = sol.main.get_metatable("sensor")

  function sensor_meta:on_activated()

    local hero = self:get_map():get_hero()
    local game = self:get_game()
    local map = self:get_map()
    local name = self:get_name()

    -- Sensors named "to_layer_X_sensor" move the hero on that layer.
    -- TODO use a custom entity or a wall to block enemies and thrown items?
    if name:match("^layer_up_sensor") then
      local x, y, layer = hero:get_position()
      if layer < map:get_max_layer() then
        hero:set_position(x, y, layer + 1)
      end
    elseif name:match("^layer_down_sensor") then
      local x, y, layer = hero:get_position()
      if layer > map:get_min_layer() then
        hero:set_position(x, y, layer - 1)
      end
    end

    -- Sensors prefixed by "dungeon_room_N" save the exploration state of the
    -- room "N" of the current dungeon floor.
    local room = name:match("^dungeon_room_(%d+)")
    if room ~= nil then
      game:set_explored_dungeon_room(nil, nil, tonumber(room))
    end
  end
end

-- Initialize the common behavior of switches specific to this quest.
local function initialize_switch()

  local switch_meta = sol.main.get_metatable("switch")

  function switch_meta:on_activated()

    -- Switches named "lever_switch*" are re-activable and have two
    -- alternative visuals.
    local name = self:get_name()

    if name:match("^lever_switch") then
      local sprite = self:get_sprite()
      local direction = sprite:get_direction()
      sprite:set_direction(1 - direction)  -- Direction may be 0 or 1.

      -- Allow to activate it again.
      sol.timer.start(self, 1000, function()
        self:set_activated(false)
      end)
    end
  end
end

-- Initializes map entity related behaviors.
local function initialize_entities()

  initialize_destructible()
  initialize_enemy()
  initialize_sensor()
  initialize_switch()
end

-- Performs global initializations specific to this quest.
function quest_manager:initialize_quest()

  initialize_map()
  initialize_entities()
end

-- Returns the font and font size to be used for dialogs
-- depending on the specified language (the current one by default).
function quest_manager:get_dialog_font(language)

  -- No font differences between languages (for now).
  return "la", 11
end

-- Returns the font and font size to be used to display text in menus
-- depending on the specified language (the current one by default).
function quest_manager:get_menu_font(language)

  -- No font differences between languages (for now).
  return "minecraftia", 8
end

return quest_manager

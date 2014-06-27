-- This script handles global behavior of this quest,
-- that is, things not related to a particular savegame.
local quest_manager = {}

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

-- Initialize sensor behavior specific to this quest.
local function initialize_sensor()

  local sensor_meta = sol.main.get_metatable("sensor")

  function sensor_meta:on_activated()

    local hero = self:get_map():get_hero()
    local name = self:get_name()

    -- Sensors named "to_layer_X_sensor" move the hero on that layer.
    -- TODO use a custom entity or a wall to block enemies and thrown items?
    if name:match("^layer_up_sensor") then
      local x, y, layer = hero:get_position()
      if layer < 2 then
        hero:set_position(x, y, layer + 1)
      end
    elseif name:match("^layer_down_sensor") then
      local x, y, layer = hero:get_position()
      if layer > 0 then
        hero:set_position(x, y, layer - 1)
      end
    end
  end
end

-- Initializes map entity related behaviors.
local function initialize_entities()

  initialize_destructible()
  initialize_sensor()
end

-- Performs global initializations specific to this quest.
function quest_manager:initialize_quest()

  initialize_entities()
end

-- Returns the font to be used for dialogs
-- depending on the specified language (the current one by default).
function quest_manager:get_dialog_font(language)

  -- No font differences between languages (for now).
  return "dialog"
end

-- Returns the font to be used to display text in menus
-- depending on the specified language (the current one by default).
function quest_manager:get_menu_font(language)

  -- No font differences between languages (for now).
  return "fixed"
end

return quest_manager


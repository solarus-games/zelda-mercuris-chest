-- Script that creates a head-up display for a game.

-- Usage:
-- local hud_manager = require("scripts/hud/hud")
-- local hud = hud_manager:create(game)

local hud_manager = {}

-- Creates and runs a HUD for the specified game.
function hud_manager:create(game)

  -- Set up the HUD.
  local hud = {
    enabled = false,
    elements = {},
    showing_dialog = false,
    top_left_opacity = 255,
    custom_command_effects = {},
  }

  function game:get_custom_command_effect(command)

    return hud.custom_command_effects[command]
  end

  -- Make the action (or attack) icon of the HUD show something else than the
  -- built-in effect or the action (or attack) command.
  -- You are responsible to override the command if you don't want the built-in
  -- effect to be performed.
  -- Set the effect to nil to show the built-in effect again.
  function game:set_custom_command_effect(command, effect)

    hud.custom_command_effects[command] = effect
  end

  -- Create each element of the HUD.
  local hearts_builder = require("scripts/hud/hearts")
  local magic_bar_builder = require("scripts/hud/magic_bar")
  local rupees_builder = require("scripts/hud/rupees")
  local small_keys_builder = require("scripts/hud/small_keys")
  local floor_builder = require("scripts/hud/floor")
  local attack_icon_builder = require("scripts/hud/attack_icon")
  local pause_icon_builder = require("scripts/hud/pause_icon")
  local item_icon_builder = require("scripts/hud/item_icon")
  local action_icon_builder = require("scripts/hud/action_icon")

  local menu = hearts_builder:new(game)
  menu:set_dst_position(-104, 6)
  hud.elements[#hud.elements + 1] = menu

  menu = magic_bar_builder:new(game)
  menu:set_dst_position(-104, 27)
  hud.elements[#hud.elements + 1] = menu

  menu = rupees_builder:new(game)
  menu:set_dst_position(8, -20)
  hud.elements[#hud.elements + 1] = menu

  menu = small_keys_builder:new(game)
  menu:set_dst_position(-36, -18)
  hud.elements[#hud.elements + 1] = menu

  menu = floor_builder:new(game)
  menu:set_dst_position(5, 70)
  hud.elements[#hud.elements + 1] = menu

  menu = pause_icon_builder:new(game)
  menu:set_dst_position(0, 7)
  hud.elements[#hud.elements + 1] = menu
  hud.pause_icon = menu

  menu = item_icon_builder:new(game, 1)
  menu:set_dst_position(11, 29)
  hud.elements[#hud.elements + 1] = menu
  hud.item_icon_1 = menu

  menu = item_icon_builder:new(game, 2)
  menu:set_dst_position(63, 29)
  hud.elements[#hud.elements + 1] = menu
  hud.item_icon_2 = menu

  menu = attack_icon_builder:new(game)
  menu:set_dst_position(13, 29)
  hud.elements[#hud.elements + 1] = menu
  hud.attack_icon = menu

  menu = action_icon_builder:new(game)
  menu:set_dst_position(26, 51)
  hud.elements[#hud.elements + 1] = menu
  hud.action_icon = menu

  -- Destroys the HUD.
  function hud:quit()

    if hud:is_enabled() then
      -- Stop all HUD elements.
      hud:set_enabled(false)
    end
  end

  -- Call this function to notify the HUD that the current map has changed.
  function hud:on_map_changed(map)

    if hud:is_enabled() then
      for _, menu in ipairs(hud.elements) do
        if menu.on_map_changed ~= nil then
          menu:on_map_changed(map)
        end
      end
    end
  end

  -- Call this function to notify the HUD that the game was just paused.
  function hud:on_paused()

    if hud:is_enabled() then
      for _, menu in ipairs(hud.elements) do
        if menu.on_paused ~= nil then
          menu:on_paused()
        end
      end
    end
  end

  -- Call this function to notify the HUD that the game was just unpaused.
  function hud:on_unpaused()

    if hud:is_enabled() then
      for _, menu in ipairs(hud.elements) do
        if menu.on_unpaused ~= nil then
          menu:on_unpaused()
        end
      end
    end
  end

  -- Called periodically to change the transparency or position of icons.
  local function check_hud()

    local map = game:get_map()
    if map ~= nil then
      -- If the hero is below the top-left icons, make them semi-transparent.
      local hero = map:get_entity("hero")
      local hero_x, hero_y = hero:get_position()
      local camera_x, camera_y = map:get_camera():get_position()
      local x = hero_x - camera_x
      local y = hero_y - camera_y
      local opacity = nil

      if hud.top_left_opacity == 255
        and not game:is_suspended()
        and x < 88
        and y < 80 then
        opacity = 96
      elseif hud.top_left_opacity == 96
        and (game:is_suspended()
        or x >= 88
        or y >= 80) then
        opacity = 255
      end

      if opacity ~= nil then
        hud.top_left_opacity = opacity
        hud.item_icon_1.surface:set_opacity(opacity)
        hud.item_icon_2.surface:set_opacity(opacity)
        hud.pause_icon.surface:set_opacity(opacity)
        hud.attack_icon.surface:set_opacity(opacity)
        hud.action_icon.surface:set_opacity(opacity)
      end

      -- During a dialog, move the action icon and the sword icon.
      if not hud.showing_dialog and
        game:is_dialog_enabled() then
        hud.showing_dialog = true
        hud.action_icon:set_dst_position(0, 54)
        hud.attack_icon:set_dst_position(0, 29)
      elseif hud.showing_dialog and
        not game:is_dialog_enabled() then
        hud.showing_dialog = false
        hud.action_icon:set_dst_position(26, 51)
        hud.attack_icon:set_dst_position(13, 29)
      end
    end

    return true  -- Repeat the timer.
  end

  -- Returns whether the HUD is currently enabled.
  function hud:is_enabled()
    return hud.enabled
  end

  -- Enables or disables the HUD.
  function hud:set_enabled(enabled)

    if enabled ~= hud.enabled then
      hud.enabled = enabled

      for _, menu in ipairs(hud.elements) do
        if enabled then
          -- Start each HUD element.
          sol.menu.start(game, menu)
        else
          -- Stop each HUD element.
          sol.menu.stop(menu)
        end
      end

      if enabled then
        sol.timer.start(hud, 50, check_hud)
      end
    end
  end

  -- Changes the opacity of an item icon.
  function hud:set_item_icon_opacity(item_index, opacity)
    hud["item_icon_" .. item_index].surface:set_opacity(opacity)
  end

  -- Start the HUD.
  hud:set_enabled(true)

  -- Return the HUD.
  return hud
end

return hud_manager


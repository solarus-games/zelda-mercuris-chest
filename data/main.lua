-- Main script of the quest.

require("scripts/features")
local game_manager = require("scripts/game_manager")
local quest_manager = require("scripts/quest_manager")
local touch_layer = require("scripts/touch_layer.lua")

local solarus_logo = require("scripts/menus/solarus_logo")
local team_logo = require("scripts/menus/team_logo")
local language_menu = require("scripts/menus/language")
local title_screen = require("scripts/menus/title")
local savegame_menu = require("scripts/menus/savegames")

-- Event called when the program starts.
function sol.main:on_started()

  -- Make quest-specific initializations.
  quest_manager:initialize_quest()

  -- Load built-in settings (audio volume, video mode, etc.).
  sol.main.load_settings()

  -- Show the Solarus logo initially.
  sol.menu.start(sol.main, solarus_logo)

  -- Touchscreen layer.
  touch_layer:start(self)

  -- Then the author's logo (Solarus Team), unless a game was started by a debug key.
  function solarus_logo:on_finished()
    if sol.main.game == nil then
      sol.menu.start(sol.main, team_logo)
    end
  end

  -- Then the language selection menu.
  function team_logo:on_finished()
    if sol.main.game == nil then
      touch_layer:set_callback_context(language_menu)
      sol.menu.start(sol.main, language_menu, false)
    end
  end

  -- Then the title screen.
  function language_menu:on_finished()
    if sol.main.game == nil then
      touch_layer:set_callback_context(title_screen)
      sol.menu.start(sol.main, title_screen, false)
    end
  end

  -- Then the savegame menu.
  function title_screen:on_finished()
    if sol.main.game == nil then
      touch_layer:set_callback_context(savegame_menu)
      sol.menu.start(sol.main, savegame_menu, false)
    end
  end
end

-- Event called when the program stops.
function sol.main:on_finished()

  sol.main.save_settings()
end

-- Event called when the player pressed a keyboard key.
function sol.main:on_key_pressed(key, modifiers)

  if key == "f5" then
    -- F5: change the video mode.
    sol.video.switch_mode()
  elseif key == "f11" or (key == "return" and modifiers.alt) then
    -- F11 or Alt + Return: switch fullscreen.
    sol.video.set_fullscreen(not sol.video.is_fullscreen())
  elseif key == "f4" and modifiers.alt then
    -- Alt + F4: stop the program.
    sol.main.exit()
  end

  return handled
end

-- Starts a game.
function sol.main:start_savegame(game)

  -- Skip initial menus if any.
  sol.menu.stop(solarus_logo)
  sol.menu.stop(team_logo)
  sol.menu.stop(language_menu)
  sol.menu.stop(title_screen)
  sol.menu.stop(savegame_menu)

  touch_layer:set_game(game)
  sol.main.game = game
  game:start()
end

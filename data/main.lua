-- Main script of the quest.

local game_manager = require("scripts/game_manager")
local debug = require("scripts/debug")
local quest_manager = require("scripts/quest_manager")

local solarus_logo = require("scripts/menus/solarus_logo")
local language_menu = require("scripts/menus/language")
local title_screen = require("scripts/menus/title")
local savegame_menu = require("scripts/menus/savegames")

-- Event called when the program starts.
function sol.main:on_started()

  -- Make quest-specific initializations.
  quest_manager:initialize_quest()

  -- Load built-in settings (audio volume, video mode, etc.).
  sol.main.load_settings()

  -- If there is a file called "debug" in the write directory,
  -- enable debugging features.
  if sol.file.exists("debug") then
    sol.menu.start(self, debug)
  end

  -- Show the Solarus logo initially.
  sol.menu.start(self, solarus_logo)

  -- Then the language selection menu, unless a game was started by a debug key.
  solarus_logo.on_finished = function()
    if self.game == nil then
      sol.menu.start(self, language_menu)
    end
  end

  -- Then the title screen.
  language_menu.on_finished = function()
    if self.game == nil then
      sol.menu.start(self, title_screen)
    end
  end

  -- Then the savegame menu.
  title_screen.on_finished = function()
    if self.game == nil then
      sol.menu.start(self, savegame_menu)
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
  sol.menu.stop(language_menu)
  sol.menu.stop(title_screen)
  sol.menu.stop(savegame_menu)

  sol.main.game = game
  game:start()
end


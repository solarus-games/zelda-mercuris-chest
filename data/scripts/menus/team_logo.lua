-- Animated Solarus Team logo

-- Usage:
-- local team_logo = require("menus/team_logo")
-- sol.menu.start(team_logo)

-----------------------------------------------------------------

local team_logo_menu = {}

-- Load Solarus Team logo sprite and text.
local logo_sprite = sol.sprite.create("menus/team_logo")
local logo_sprite_width, logo_sprite_height = logo_sprite:get_size()

local text_img = sol.surface.create("menus/team_logo_text.png")
local txt_width, txt_height = text_img:get_size()

-- Compute each item position.
local vertical_margin = 13
local full_logo_width = math.max(logo_sprite_width, txt_width)
local full_logo_height = logo_sprite_height + vertical_margin + txt_height

local logo_sprite_x = (full_logo_width - logo_sprite_width) / 2
local logo_sprite_y = 0
logo_sprite:set_xy(logo_sprite_x, logo_sprite_y)

local text_x =  (full_logo_width - txt_width) / 2
local text_y = full_logo_height - txt_height
text_img:set_xy(text_x, text_y)

-- Counter for the number of rotations.
local rotation_count = 0
local max_rotation_count = 3

-- Handling sprite delay.
local sprite_initial_delay = 1
local sprite_final_delay = 80
local sprite_delay_diff = sprite_final_delay - sprite_initial_delay

-- Animation steps.
local NO_STATE, ROTATING, SHINING, DISPLAYING_TEXT, FINAL = 0, 1, 2, 3, 4
local animation_step = NO_STATE

-----------------------------------------------------------------

-- Quadratic easing in function:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)
local function get_easing_value(t, b, c, d)
  t = t / d
  return c * math.pow(t, 2) + b
end

-----------------------------------------------------------------

-- Count the number of rotation, and each time decelerate a bit.
function logo_sprite:on_frame_changed(animation, frame)
  if animation_step == 0 then
    return
  end

  if animation == "rotation" and frame == 0 then
    local current_time = rotation_count / (max_rotation_count - 1)

    -- Decrement the speed.
    local new_delay = get_easing_value(current_time, sprite_initial_delay, sprite_delay_diff, 1)
    logo_sprite:set_frame_delay(new_delay)

    -- Increment the count.
    rotation_count = rotation_count + 1

    -- Stop when max_rotation_count is reach.
    if(rotation_count == max_rotation_count) then
      logo_sprite:set_paused(true)
      team_logo_menu:go_to_step(SHINING)
    end
  end

end

-- Automatically go to the next step.
function logo_sprite:on_animation_finished(animation)
  if animation == "rotation" then
    team_logo_menu:go_to_step(SHINING)
  elseif animation == "shine" then
    team_logo_menu:go_to_step(DISPLAYING_TEXT)
  end
end

----------------------------------------------------------------

-- Launch the animation.
function team_logo_menu:start_animation()
  -- First, reset everything.
  team_logo_menu:go_to_step(NO_STATE)
  -- Start step 1.
  team_logo_menu:go_to_step(ROTATING)
end

-- Define the current step of the animation.
function team_logo_menu:go_to_step(step)
  -- Step 1: rotate the logo on itself.
  if step == ROTATING then
    animation_step = step
    rotation_count = 0
    logo_sprite:fade_in(5)
    logo_sprite:set_animation("rotation")
    logo_sprite:set_direction(0)
    logo_sprite:set_frame_delay(sprite_initial_delay)
    logo_sprite:set_frame(7)

  -- Step 2: shine on the logo.
  elseif step == SHINING then
    animation_step = step
    rotation_count = 0
    logo_sprite:set_animation("shine")
    logo_sprite:set_direction(0)

  -- Step 3: No animation on logo, launch timer for text.
  elseif step == DISPLAYING_TEXT then
    animation_step = step
    rotation_count = 0
    logo_sprite:set_animation("static")
    logo_sprite:set_direction(0)

    -- Start timer before displaying text.
    sol.timer.start(team_logo_menu, 500, function()
      team_logo_menu:go_to_step(FINAL)
    end)

  -- Step 3: everything is displayed, no more animation.
  elseif step == FINAL then
    animation_step = step
    rotation_count = 0
    logo_sprite:set_animation("static")
    logo_sprite:set_direction(0)
    sol.audio.play_sound("intro")

    -- Start the final timer.
    sol.timer.start(team_logo_menu, 700, function()
      -- Fade-out both the logo and the text.
      logo_sprite:fade_out()
      text_img:fade_out()
      -- Start another timer to quit the menu.
      sol.timer.start(team_logo_menu, 900, function()
        sol.menu.stop(team_logo_menu)
      end)
    end)

  -- Reset the animation in default state.
  else
    animation_step = NO_STATE
    rotation_count = 0
    logo_sprite:set_animation("static")
    logo_sprite:set_direction(0)
  end
end

-----------------------------------------------------------------

function team_logo_menu:on_started() 
  -- Start the animation.
  team_logo_menu:start_animation()
end

-- Draws this menu on the quest screen.
function team_logo_menu:on_draw(screen)
  -- Get logo coordinates in the screen.
  local screen_width, screen_height = screen:get_size()
  local full_logo_x = (screen_width - full_logo_width) / 2
  local full_logo_y = (screen_height - full_logo_height) / 2
  
  -- Draw logo sprite.
  logo_sprite:draw(screen, full_logo_x, full_logo_y)

  -- Draw the text (only after step 1 is done).
  if animation_step > DISPLAYING_TEXT then
    text_img:draw(screen, full_logo_x, full_logo_y)
  end
end

-- Key pressed: skip menu or quit Solarus.
function team_logo_menu:on_key_pressed(key)
  if key == "return" or key == "space" then
    return  team_logo_menu:try_skip_menu()
  elseif key == "escape" then
    sol.main.exit()
    return true
  end
end

-- Mouse pressed: skip menu.
function team_logo_menu:on_mouse_pressed(button, x, y)
  if button == "left" or button == "right" then
    return team_logo_menu:try_skip_menu()
  end
end

-- Joypad pressed: skip menu.
function team_logo_menu:on_joypad_button_pressed(button)
  if button == 1 then
    return team_logo_menu:try_skip_menu()
  end
end

-- Try to skip the menu: go directly to the final step
function team_logo_menu:try_skip_menu()
  if animation_step ~= FINAL then
    team_logo_menu:go_to_step(FINAL)
    return true
  else
    return false
  end
end

-----------------------------------------------------------------

-- Return the menu to the caller
return team_logo_menu

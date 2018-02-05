-- @author std::gregwar
--
--This script allows to construct cutscenes in a flat way, i.e. without chaining callbacks
--
-- Usage:
--
-- require() the script, use builder function to start building a cutscene
--
-- Example:
--
-- --In a map script file
--
-- local cutscene = require('scripts/maps/cutscene')
--
-- local game, map, hero = --init those vals as always

-- function map:start_cinematic()
--   cutscene.builder(game, map, hero)
--   .wait(1000) --wait one second
--   .dialog('my_dialog') --start a dialog
--   .wait(500) --wait between dialog and next cell
--   .hero_start_treasure(...)
--    ....
--   .start() --start the cinematic we just built
-- end
--
-- Limitations:
--
-- Pay attention to the fact that all the 'cells' are created at the same time, i.e before
-- the cinematic starts. This implies that a exec cell that modifies up-values, will not have an effect
-- on next cells, as they are already constructed.
-- 
-- You can, howewer use the fact that returned values in a exec closure are forwarded to the next cell
--
-- Example:
--
-- cutscene.builder(game, map, hero)
-- .exec(function() return 1 end)
-- .exec(function(val) print(val) end)
-- .start()
-- -- will print '1', as the returned value in last exec has been fowarded
-- -- cell .wait forward the preceding values

local cutscene = {}

local utils  = {}

--used internally to unpack properties
local function unpack_or_val(v)
  if type(v) == 'table' then
    return unpack(v)
  else
    return v
  end
end

--ensure f is callable
local function safe(f)
  return f or function() end
end

--apply the properties props by searching the object for setters
function utils.apply_properties(obj,props)
  for pname,pval in pairs(props) do
    local sname = 'set_'.. pname
    local setter = obj[sname]
    safe(setter)(obj,unpack_or_val(pval))
  end
end

local builder_meta = {}

local flagers = {}

--flagers allow to add callless 'flags'
--in the middle of the call chain
function flagers.dont_wait_for(b)
  b.flags.wait = nil
end

function flagers.no_continue(b)
  b.flags.no_cont = true
end

--check if there is a flager for the given key
--resume normal behaviour if key is a normal key
function builder_meta.__index(b,k)
  local p = rawget(b,k);
  if not p then --if there is actual prop search for flager
    local flager = flagers[k]
    if flager then
      flager(b)
      return b
    end --return nil when no flager
  else -- return actual prop
    return p
  end
end

--create a cutscene builder
function cutscene.builder(game, map, hero)
  local b = {}
  local bhead = b

  --reset flags to default
  --called after each cells
  function b.reset_flags()
    --setup default flags
    b.flags = {
      wait = true;
    }
    return b
  end

  b.reset_flags()

  --------------------
  -- CELLS
  --------------------

  -- base cell that run your function closure
  -- your function is given a callable cont that you must call to continue
  -- the cutscene, unless you use .dont_wait_for. flag before.
  -- closure(cont,vals returned from the preceding cell)
  --
  -- any val passed to cont() are forwarded to the next cell
  -- cells like wait forward the received args to the next cell
  function b.and_then(closure)
    local cell = {}
    --save wait flag as upval
    local wait = b.flags.wait
    local no_cont = b.flags.no_cont
    function bhead.next(...)
      if wait then
        closure(safe(cell.next),...)
      else --call next directly if wait flag is down
        if no_cont then --need continuation?
          safe(cell.next)(closure(...))
        else
          safe(cell.next)(closure(safe(),...))
        end 
      end
    end
    b.reset_flags()
    bhead = cell;
    return b;
  end

  --shorthand for .dont_wait_for.and_then()
  function b.exec(closure)
    return b.dont_wait_for.no_continue.and_then(closure)
  end

  --start a timer and resume next cell when it expires
  --second arg is an optional context, default one will be the map
  function b.wait(time,op_ctx)
    return b.and_then(
      function(cont,...)
        local args = {...}
        local function curried_cont()
          return cont(unpack(args))
        end
        return sol.timer.start(op_ctx or map,time,curried_cont)
      end
    )
  end

  --play a sound, this don't wait for the sound to finish
  function b.sound(sound_id)
    return b.and_then(
      function(cont)
        sol.audio.play_sound(sound_id)
        cont()
      end
    )
  end

  --show a dialog using game:start_dialog, this continues the
  --cell chain after the dialog ends, next cell get the dialog result
  --as the dialog callback do usually
  function b.dialog(dialog_id,info)
    return b.and_then(
      function(cont,passed_info)
        game:start_dialog(dialog_id,info or passed_info,cont)
      end
    )
  end

  --create a movement and starts it
  --first argument is a params table that is typicaly like this :
  --{ type ='type_of_movement_to_create',entity=entity_to_move,
  --  properties = {speed = 30,target = {x,y},...}
  --second optional argument is a function that will receive the movement
  -- and can do a last setup before it is started
  -- op_setup_closure(mov)
  function b.movement(params,op_setup_closure)
    return b.and_then(
      function(cont)
        local mov = sol.movement.create(params.type)
        utils.apply_properties(mov,params.properties)
        safe(op_setup_closure)(mov)
        mov:start(params.entity,cont)
        return mov
      end
    )
  end

  --start an animation on the given sprite
  -- use with .dont_wait_for. flag if the animation loops,
  -- otherwise the cinematic will get stuck
  function b.sprite_animation(sprite,animation)
    return b.and_then(
      function(cont)
        sprite:set_animation(animation,cont)
      end
    )
  end

  --same as sprite_animation but uses hero:set_animation
  function b.hero_animation(animation)
    return b.and_then(
      function(cont)
        hero:set_animation(animation,cont)
      end
    )
  end

  --calls hero:start_treasure, forwarding any arguments, and then resume cell chain
  function b.hero_start_treasure(...)
    local args = {...}
    return b.and_then(
      function(cont)
        hero:start_treasure(unpack(args),cont);
      end
    )
  end

  --calls hero:start_victory, and the resume cell chain
  function b.hero_victory()
    return b.and_then(
      function(cont)
        hero:start_victory(cont)
      end
    )
  end

  --set the direction of a given entity
  function b.set_direction(entity,direction)
    return b.exec(
      function()
        entity:set_direction(direction)
      end
    )
  end

  --start the constructed cutscene
  function b.start(...)
    b.next(...)
  end

  -------------------------------------------------------
  -- END CELLS
  -------------------------------------------------------

  return setmetatable(b,builder_meta)
end

return cutscene

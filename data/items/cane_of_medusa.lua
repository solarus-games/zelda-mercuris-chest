local item = ...

local turn_enemy_to_stone
local turn_stone_to_enemy

function item:on_created()

  self:set_savegame_variable("possession_cane_of_medusa")
  self:set_assignable(true)
end

function item:on_obtained(variant, savegame_variable)

  -- Give the magic bar if necessary.
  local magic_bar = self:get_game():get_item("magic_bar")
  if not magic_bar:has_variant() then
    magic_bar:set_variant(1)
  end
end

function item:on_using()

  local game = item:get_game()
  local hero = item:get_map():get_hero()

  -- Detect enemies with an invisible custom entity.
  local x, y, layer = hero:get_position()
  local direction4 = hero:get_direction()
  if direction4 == 0 then x = x + 12
  elseif direction4 == 1 then y = y - 12
  elseif direction4 == 2 then x = x - 12
  else y = y + 12
  end

  local cane = game:get_map():create_custom_entity{
    x = x,
    y = y,
    layer = layer,
    width = 8,
    height = 8,
    direction = 0,
  }
  cane:set_origin(4, 5)
  cane:add_collision_test("overlapping", function(cane, entity)

    if entity:get_type() ~= "enemy" then
      return
    end

    if entity:is_vulnerable_to_medusa() then
      turn_enemy_to_stone(entity)
    end
  end)

  -- Start the animation.
  hero:set_animation("hammer", function()
    hero:unfreeze()
    cane:remove()
  end)
end

-- Transforms an enemy to a block with the same sprite.
function turn_enemy_to_stone(enemy)

  local map = enemy:get_map()
  local x, y, layer = enemy:get_position()

  local block = map:create_block({
    x = x,
    y = y,
    layer = layer,
    sprite = enemy:get_sprite():get_animation_set(),
    pushable = true,
    pullable = true,
    maximum_moves = 2,
  })
  block:bring_to_back()
  enemy:set_enabled(false)
  block.original_enemy = enemy

  local sprite = block:get_sprite()
  if sprite:has_animation("immobilized") then
    sprite:set_animation("immobilized")
  end

  sol.timer.start(map, 6000, function()
    turn_stone_to_enemy(block)
  end)
end

-- Transforms a block back to its original enemy.
function turn_stone_to_enemy(block)

  local enemy = block.original_enemy
  assert(enemy ~= nil)
  enemy:set_enabled(true)
  enemy:set_position(block:get_position())
  block:remove()
end

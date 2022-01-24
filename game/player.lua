local module = require('hug.module')
local vector2 = require('hug.vector2')
local adsl = require('hug.anim.dsl')
local animator = require('hug.anim.animator')
local animutil = require('game.animutil')

local player = module.new()

local sprite = love.graphics.newImage('assets/finalplayer.png')

local aset = adsl.run(function()
  animation 'default' {
    frame {
      source = rectangle(0, 0, 64, 64), duration = '100ms',
      attachment('radius', 2, 0)
    },
    frame {
      source = rectangle(64, 0, 64, 64), duration = '100ms',
      attachment('radius', 2, 0)
    },
    frame {
      source = rectangle(0, 64, 64, 64), duration = '100ms',
      attachment('radius', 2, 0)
    },
    frame {
      source = rectangle(64, 64, 64, 64), duration = '100ms',
      attachment('radius', 2, 0)
    }
  }
end)
animutil.genfquads(aset, sprite)

function player.new()
  local instance = {
    p = vector2.new(),
    lastp = vector2.new(),
    v = vector2.new(),
    r = 4,
    predictvec = vector2.new(),
    bulletside = 'left',
    bulletcd = 0,
    focused = false,
    anim = animator.new(aset)
  }
  instance.anim:play('default')
  return setmetatable(instance, player)
end

function player:update(dt)
  self.anim:update(dt)
  self.lastp:set(self.p:x(), self.p:y())
  self.p:add(self.v)

  self.bulletcd = self.bulletcd - 1
  if self.bulletcd < 0 then
    self.bulletcd = 0
  end
end

function player:predict(a)
  vector2.lerp(self.lastp, self.p, a, self.predictvec)
  return self.predictvec
end

function player:draw(a)
  local rx, ry = unpack(self:predict(a))
  local f = self.anim:frame()
  love.graphics.draw(sprite, f.quad, rx, ry, 0, 1, 1, f:width() / 2, f:height() / 2)
  --love.graphics.setColor(255,0,0)
  --love.graphics.circle('fill', rx, ry, self.r)
  --love.graphics.setColor(255,255,255)
end

function player:canfire()
  return self.bulletcd <= 0
end

function player:setfired()
  self.bulletcd = 2
  if self.bulletside == 'left' then
    self.bulletside = 'right'
  else
    self.bulletside = 'left'
  end
end

function player:bulletxoffs()
  local mod = 1
  --if self.focused then
  --  mod = 0.3
  --end

  --if self.bulletside == 'left' then
  --  return -18 * mod
  --else
  --  return 18 * mod
  --end
  return 18
end

function player:setfocus(v)
  self.focused = v
end

function player:speed()
  if self.focused then
    return 5
  else
    return 10
  end
end

function player:width()
  return self.anim:frame():width()
end

function player:height()
  return self.anim:frame():height()
end

return player

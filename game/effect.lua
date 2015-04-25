local module = require('hug.module')
local animator = require('hug.anim.animator')
local vector2 = require('hug.vector2')
local sound = require('game.sound')

local effect = module.new()

function effect.new(image, aset, aname, x, y, delay, sound)
  local instance = {
    image = image,
    anim = animator.new(aset),
    p = vector2.new(x, y),
    alive = true,
    lastidx = 0,
    delay = delay or 0,
    sound = sound
  }
  instance.anim:play(aname)
  return setmetatable(instance, effect)
end

function effect:update(dt)
  if self.delay > 0 then
    self.delay = self.delay - 1
    if (self.delay <= 0 and self.sound) then
      sound.play(self.sound)
    end
  else
    self.anim:update(dt)

    -- ideally we could get this info from an animator...
    local thisidx = self.anim.frameidx
    if thisidx < self.lastidx then
      self.alive = false
    end
    self.lastidx = thisidx
  end
end

function effect:draw()
  if self.delay <= 0 then
    local rx, ry = unpack(self.p)
    local f = self.anim:frame()
    love.graphics.draw(self.image, f.quad, math.floor(rx - f:width() / 2), math.floor(ry - f:height() / 2))
  end
end

return effect

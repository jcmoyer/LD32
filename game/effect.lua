local module = require('hug.module')
local animator = require('hug.anim.animator')
local vector2 = require('hug.vector2')

local effect = module.new()

function effect.new(image, aset, aname, x, y)
  local instance = {
    image = image,
    anim = animator.new(aset),
    p = vector2.new(x, y),
    alive = true,
    lastidx = 0
  }
  instance.anim:play(aname)
  return setmetatable(instance, effect)
end

function effect:update(dt)
  self.anim:update(dt)

  -- ideally we could get this info from an animator...
  local thisidx = self.anim.frameidx
  if thisidx < self.lastidx then
    self.alive = false
  end
  self.lastidx = thisidx
end

function effect:draw()
  local rx, ry = unpack(self.p)
  local f = self.anim:frame()
  love.graphics.draw(self.image, f.quad, rx - f:width() / 2, ry - f:height() / 2)
end

return effect

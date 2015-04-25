local module = require('hug.module')
local vector2 = require('hug.vector2')

local background = module.new()
local layer = module.new()

background.layer = layer

function layer.new(image, scrollspeed)
  local instance = {
    image = image,
    scrollspeed = scrollspeed
  }
  return setmetatable(instance, layer)
end

function background.new(w, h)
  local instance = {
    layers = {},
    xscroll = 0,
    yscroll = 0,
    width = w,
    height = h,
    v = vector2.new()
  }
  return setmetatable(instance, background)
end

function background:update()
  local vx, vy = unpack(self.v)
  self.xscroll = self.xscroll + vx
  self.yscroll = self.yscroll + vy
end

function background:predict(a)
  local vx, vy = unpack(self.v)
  local xs = self.xscroll + vx * a
  local ys = self.yscroll + vy * a
  return xs, ys
end

function background:add(l)
  table.insert(self.layers, l)
end

function background:draw(a, x, y)
  local minspeed = 1
  for i = 1, #self.layers do
    minspeed = math.min(minspeed, self.layers[i].scrollspeed)
  end

  for i = 1, #self.layers do
    local l = self.layers[i]
    -- number of layers along x axis
    local numx = self.width / l.image:getWidth() + 1
    local numy = self.height / l.image:getHeight() + 1

    local xs, ys = self:predict(a)

    for i = -1,numx do
      for j = -1,numy do
        love.graphics.draw(
          l.image,
          math.floor(((xs+x)*l.scrollspeed % l.image:getWidth()) + i * l.image:getWidth()),
          math.floor(((ys+y)*l.scrollspeed % l.image:getHeight()) + j * l.image:getHeight()))
      end
    end
  end
end

function background:setscroll(x, y)
  if x then
    self.xscroll = x
  end
  if y then
    self.yscroll = y
  end
end

return background

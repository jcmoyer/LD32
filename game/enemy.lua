local module = require('hug.module')
local vector2 = require('hug.vector2')
local esc = require('game.enemyscriptcontext')
local animator = require('hug.anim.animator')

local enemy = module.new()

local flash = love.graphics.newShader [[
extern float flash;

vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord) {
    vec4 outputcolor = Texel(tex, texcoord) * vcolor;
    outputcolor.r = outputcolor.r + flash * (255 * flash - outputcolor.r);
    outputcolor.g = outputcolor.g + flash * (255 * flash - outputcolor.g);
    outputcolor.b = outputcolor.b + flash * (255 * flash - outputcolor.b);
    return outputcolor;
}
]]

function enemy.setshader(state)
  if state then
    love.graphics.setShader(flash)
  else
    love.graphics.setShader()
  end
end

function enemy.new(enemyinfo, spawninfo, stage)
  local instance = {
    image = enemyinfo.image,
    info = enemyinfo,
    alive = true,
    p = vector2.new(spawninfo.x, spawninfo.y),
    v = vector2.new(),
    accelangle = 0,
    accelmag = 0,
    anim = animator.new(enemyinfo.aset),
    predictvec = vector2.new(),
    sc = nil,
    hp = enemyinfo.hp,
    flash = 0
  }
  instance.sc = esc.new(stage, instance)
  if instance.info.spawn then
    instance.info.spawn(instance.sc, spawninfo.userdata)
  end
  return setmetatable(instance, enemy)
end

function enemy:update(dt)
  if self.info.update then
    self.info.update(self.sc)
  end

  -- angular acceleration
  local direction = self:direction()
  direction = direction + self.accelangle
  self.v:add(
    math.cos(direction) * self.accelmag,
    math.sin(direction) * self.accelmag)

  self.p:add(self.v)
  self.anim:update(dt)
  self.flash = self.flash - 1
  if self.flash < 0 then
    self.flash = 0
  end
end

function enemy:predict(a)
  self.predictvec:set(
    self.p[1],
    self.p[2])
  self.predictvec:add(
    self.v[1] * a,
    self.v[2] * a)

  return self.predictvec
end

function enemy:draw(a)
  local rx, ry = unpack(self:predict(a))
  --love.graphics.rectangle('fill', rx, ry, 100, 100)
  local f = self.anim:frame()

  if self.flash > 0 then
    flash:send('flash', 1)
  else
    flash:send('flash', 0)
  end

  love.graphics.draw(self.image, f.quad, math.floor(rx - f:width() / 2), math.floor(ry - f:height() / 2))
end

function enemy:kill()
  self.alive = false
end

function enemy:direction()
  return math.atan2(self.v[2], self.v[1])
end

function enemy:damage(amount)
  self.hp = self.hp - amount
  self.flash = 2
  if self.hp <= 0 then
    self.alive = false
  end
end

function enemy:radius()
  return self.anim:frame():attachment('radius')[1]
end

function enemy:pointval()
  return self.info.points or 500
end

return enemy

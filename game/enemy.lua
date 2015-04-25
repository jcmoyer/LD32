local module = require('hug.module')
local vector2 = require('hug.vector2')
local esc = require('game.enemyscriptcontext')
local animator = require('hug.anim.animator')

local enemy = module.new()

function enemy.new(enemyinfo, spawninfo, stage)
  local anim
  if enemyinfo.aset then
    anim = animator.new(enemyinfo.aset)
  end
  local instance = {
    image = enemyinfo.image,
    info = enemyinfo,
    alive = true,
    p = vector2.new(spawninfo.x, spawninfo.y),
    v = vector2.new(),
    accelangle = 0,
    accelmag = 0,
    anim = anim,
    predictvec = vector2.new(),
    sc = nil,
    hp = enemyinfo.hp,
    maxhp = enemyinfo.hp,
    flash = 0,
    boss = enemyinfo.boss or false
  }
  instance.sc = esc.new(stage, instance)
  setmetatable(instance, enemy)
  if instance.info.spawn then
    instance.info.spawn(instance.sc, spawninfo.userdata)
  end
  return instance
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
  if self.anim then
    self.anim:update(dt)
  end
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
  if self.anim then
    local rx, ry = unpack(self:predict(a))
    --love.graphics.rectangle('fill', rx, ry, 100, 100)
    local f = self.anim:frame()

    love.graphics.draw(self.image, f.quad, math.floor(rx - f:width() / 2), math.floor(ry - f:height() / 2))
  end
end

function enemy:kill()
  self.alive = false
end

function enemy:direction()
  return math.atan2(self.v[2], self.v[1])
end

function enemy:damage(amount)
  self.hp = self.hp - amount
  if not self.boss then
    self.flash = 2
  end
  if self.hp <= 0 then
    self.alive = false
  end
end

function enemy:radius()
  if self.anim then
    return self.anim:frame():attachment('radius')[1]
  else
    return 0
  end
end

function enemy:pointval()
  return self.info.points or 500
end

function enemy:isflashing()
  return self.flash > 0
end

return enemy

local module = require('hug.module')
local sound = require('game.sound')

local esc = module.new()

function esc.new(stage, enemy)
  local instance = {
    enemy = enemy,
    stage = stage
  }
  return setmetatable(instance, esc)
end

function esc:spawnbullet(xv, yv)
  local sx, sy = unpack(self.enemy.p)
  self.stage:spawnbullet(sx, sy, xv, yv)
end

function esc:spawnbulletangular(name, theta, m)
  local sx, sy = unpack(self.enemy.p)
  local xv = math.cos(theta) * m
  local yv = math.sin(theta) * m
  return self.stage:spawnbullet(name, sx, sy, xv, yv)
end

function esc:getp()
  return unpack(self.enemy.p)
end

function esc:getv()
  return unpack(self.enemy.v)
end

function esc:setv(x, y)
  self.enemy.v:set(x, y)
end

function esc:seta(r, m)
  self.enemy.accelangle = r
  self.enemy.accelmag = m
end

function esc:angletoplayer()
  local pp = self.stage.player.p
  local ep = self.enemy.p
  local dv = pp - ep
  return math.atan2(dv[2], dv[1])
end

function esc:gethp()
  return self.enemy.hp
end

function esc:sethp(n)
  self.enemy.hp = n
end

function esc:setmusic(name)
  return self.stage:setmusic(name)
end

function esc:playsound(name)
  return sound.play(name)
end

function esc:onscreen()
  return self.stage.bounds:contains(unpack(self.enemy.p))
end

function esc:spawnenemy(name, x, y, userdata)
  self.stage:spawnenemy({frame=0, name=name, x=x, y=y, spawned=true, userdata=userdata})
end

function esc:spawnzone(name)
  return self.stage.spawnzone(name)
end

function esc:resetbulletzone()
  self.stage.bulletzone = self.stage.bounds:clone()
  self.stage.bulletzone:inflate(40, 40)
end

function esc:setbulletzone(x,y)
  self.stage.bulletzone = self.stage.bounds:clone()
  self.stage.bulletzone:inflate(x,y)
end

return esc

local module = require('hug.module')
local rectangle = require('hug.rectangle')
local bullet = require('game.bullet')
local enemy = require('game.enemy')
local eis = require('game.enemyinfoscript')
local player = require('game.player')
local collision = require('game.collision')
local effect = require('game.effect')
local animutil = require('game.animutil')
local music = require('game.music')
local sound = require('game.sound')
local background = require('game.background')

local adsl = require('hug.anim.dsl')
local effectset = adsl.run(function()
  animation 'explosion' {
    frame {
      source = rectangle.new(0, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(32, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(64, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(96, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(128, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(160, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(192, 0, 32, 32), duration = '30ms'
    },
    frame {
      source = rectangle.new(224, 0, 32, 32), duration = '30ms'
    }
  }

  animation 'pop' {
    frame {
      source = rectangle.new(0, 192-32, 32, 32), duration = '50ms'
    },
    frame {
      source = rectangle.new(32, 192-32, 32, 32), duration = '50ms'
    },
    frame {
      source = rectangle.new(64, 192-32, 32, 32), duration = '50ms'
    },
    frame {
      source = rectangle.new(96, 192-32, 32, 32), duration = '50ms'
    }
  }
end)
local effects = love.graphics.newImage('assets/effects.png')
animutil.genfquads(effectset, effects)

local starfield = love.graphics.newImage('assets/starfield.png')
local starfieldclose = love.graphics.newImage('assets/starfield_close.png')
local planets = love.graphics.newImage('assets/planets.png')

local stage = module.new()

local bounds = rectangle.new(0, 0, 600, 700)
local activezone = bounds:clone()
activezone:inflate(100, 100)
local bulletzone = bounds:clone()
bulletzone:inflate(40,40)

function stage.spawnzone(name)
  if name == 'left' then
    return activezone:x()
  elseif name == 'right' then
    return activezone:right()
  elseif name == 'top' then
    return activezone:y()
  elseif name == 'bottom' then
    return activezone:bottom()
  elseif name == 'xcenter' then
    return (bounds:right() - bounds:x()) / 2
  elseif name == 'ycenter' then
    return (bounds:bottom() - bounds:y()) / 2
  end
  error('invalid spawnzone name')
end

function stage.new(spawninfo, musicname)
  local instance = {
    player = player.new(),
    boss = nil,
    score = 0,
    lives = 5,
    bullets = {},
    playerbullets = {},
    enemies = {},
    effects = {},
    bounds = bounds,
    activezone = activezone,
    bulletzone = bulletzone,
    frame = 0,
    invinc = 0,
    spawninfo = spawninfo,
    music = music.new(musicname),
    killfade = 0,
    bg = background.new(bounds:width(), bounds:height()),
    gameover = false,
    win = false
  }
  instance.music:restart()

  instance.bg:add(background.layer.new(planets, 0.08))
  instance.bg:add(background.layer.new(starfield, 0.12))
  instance.bg:add(background.layer.new(starfieldclose, 0.2))

  return setmetatable(instance, stage)
end

function stage:startlevel()
  local px = self.bounds:center()
  local py = self.bounds:bottom() - 64
  self.player.p:set(px, py)
end

function stage:killplayer()
  if self.invinc > 0 then
    return false
  end

  local px, py = unpack(self.player.p)
  table.insert(self.effects,
    effect.new(effects, effectset, 'explosion', px, py))

  self.bullets = {}
  self.killfade = 150
  sound.play('pop')
  self:startlevel()

  self.lives = self.lives - 1
  if self.lives < 0 then
    self.gameover = true
  end
  self.invinc = 100
  return true
end

function stage:update(dt)
  self.music:update()

  self.killfade = self.killfade - 5
  if self.killfade <= 0 then
    self.killfade = 0
  end

  self.invinc = self.invinc - 1
  if self.invinc <= 0 then
    self.invinc = 0
  end
  self.frame = self.frame + 1

  for i = 1,#self.spawninfo do
    local info = self.spawninfo[i]
    if (self.frame >= info.frame and not info.spawned) then
      local ei = eis.runfile(eis.filename(info.name))
      local en = enemy.new(ei, info, self)
      table.insert(self.enemies, en)
      info.spawned = true
    end
  end

  local px, py = unpack(self.player.p)
  for i = #self.enemies,1,-1 do
    local e = self.enemies[i]
    e:update(dt)
    local ex, ey = unpack(e.p)
    if not self.activezone:contains(ex, ey) then
      table.remove(self.enemies, i)
    end
    if collision.cc(px, py, self.player.r, ex, ey, e:radius()) then
      self:killplayer()
    end
  end

  for i = #self.bullets,1,-1 do
    local b = self.bullets[i]
    b:update(dt)
    local bx, by = unpack(b.p)
    if collision.cc(px, py, self.player.r, bx, by, b:radius()) then
      if self:killplayer() then
        break
      end
    end
    if not self.bulletzone:contains(unpack(b.p)) then
      b:kill()
    end
    if not b.alive then
      table.remove(self.bullets, i)
    end
  end

  for i = #self.playerbullets,1,-1 do
    local b = self.playerbullets[i]
    local bx, by = unpack(b.p)
    b:update(dt)
    if not self.bulletzone:contains(unpack(b.p)) then
      b:kill()
    else
      for j = #self.enemies,1,-1 do
        local e = self.enemies[j]
        local ex, ey = unpack(e.p)
        if collision.cc(ex, ey, e:radius(), bx, by, b:radius()) then
          b:kill()
          e:damage(1)
          if not e.alive then
            sound.play('pop')
            table.remove(self.enemies, j)
            self.score = self.score + e:pointval()
            table.insert(self.effects,
              effect.new(effects, effectset, 'explosion', ex, ey))
          end
          break
        end
      end
    end
    if not b.alive then
      table.remove(self.playerbullets, i)
    end
  end

  for i = #self.effects,1,-1 do
    local e = self.effects[i]
    e:update(dt)
    if not e.alive then
      table.remove(self.effects, i)
    end
  end

  self.player:update(dt)

  local px, py = unpack(self.player.p)
  local pw = self.player:width()
  local ph = self.player:height()
  if px - pw / 2 < bounds:x() then
    self.player.p[1] = bounds:x() + pw / 2
  elseif px + pw / 2 > bounds:right() then
    self.player.p[1] = bounds:right() - pw / 2
  end
  if py - ph / 2 < bounds:y() then
    self.player.p[2] = bounds:y() + ph / 2
  elseif py + ph / 2 > bounds:bottom() then
    self.player.p[2] = bounds:bottom() - ph / 2
  end

  if self.boss then
    if self.boss.hp <= 0 then
      self.gameover = true
      self.win = true
    end
  end

  self.bg:setscroll(-self.player.p[1], -self.player.p[2] + self.frame)
end

function stage:draw(a)
  local sx, sy = self:screenpos(love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.push()
  love.graphics.translate(sx, sy)

  love.graphics.setColor(20, 12, 28)
  love.graphics.rectangle('fill', unpack(self.bounds))
  love.graphics.setColor(255, 255, 255)

  self.bg:draw()

  for i = 1,#self.playerbullets do
    self.playerbullets[i]:draw(a)
  end

  if (self.invinc > 0 and math.floor(self.invinc / 8) % 2 == 0) then
    love.graphics.setColor(218, 212, 94)
  end
  self.player:draw(a)
  love.graphics.setColor(255, 255, 255)

  enemy.setshader(true)
  for i = 1,#self.enemies do
    self.enemies[i]:draw(a)
  end
  enemy.setshader()

  for i = 1,#self.effects do
    self.effects[i]:draw(a)
  end
  for i = 1,#self.bullets do
    self.bullets[i]:draw(a)
  end
  --love.graphics.rectangle('line', unpack(self.bounds))

  love.graphics.setColor(255, 255, 255, self.killfade)
  love.graphics.rectangle('fill', unpack(self.bounds))
  love.graphics.setColor(255, 255, 255)

  --love.graphics.print('mem = ' .. math.floor(collectgarbage('count')) .. 'kb',0, 0)
  --love.graphics.print('enemies = ' .. #self.enemies, 0, 40)
  --
  --love.graphics.print('bullets = ' .. #self.bullets, 200, 40)
  --love.graphics.print('frame = ' .. self.frame, 200, 0)
  love.graphics.pop()
end

function stage:spawnbullet(name, x, y, vx, vy)
  local b = bullet.new(name, x, y, vx, vy)
  table.insert(self.bullets, b)
  return b
end

function stage:screenpos(width, height)
  local x = width / 2 - self.bounds[3] / 2
  local y = height / 2 - self.bounds[4] / 2
  return x, y
end

function stage:spawnplayerbullet()
  if self.player:canfire() then
    local px, py = unpack(self.player.p)
    local b = bullet.new('carrot', px + self.player:bulletxoffs(), py, 0, -5)
    b.accelmag = 0.5
    b.accelangle = (math.random() * 0.1) - (math.random() * 0.1)
    table.insert(self.playerbullets, b)
    self.player:setfired()
    return true
  end
  return false
end

function stage:setmusic(name)
  self.music:stop()
  self.music = music.new(name)
  self.music:start()
end

function stage:stopmusic()
  self.music:stop()
end

function stage:setboss(e)
  self.boss = e
end

function stage:spawnenemy(spawninfo)
  local ei = eis.runfile(eis.filename(spawninfo.name))
  local en = enemy.new(ei, spawninfo, self)
  table.insert(self.enemies, en)
end


return stage

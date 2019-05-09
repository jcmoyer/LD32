local module = require('hug.module')
local gamestate = require('hug.gamestate')
local playstate = require('states.playstate')
local rectangle = require('hug.rectangle')
local bullet = require('game.bullet')

local menustate = module.new(gamestate)

local titlefont = love.graphics.newFont(48)
local font = love.graphics.newFont(24)

function menustate.new()
  local instance = {
    counter = 0,
    accumulator = 0,
    bullets = {},
    bulletzone = rectangle.new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  }
  return setmetatable(instance, menustate)
end

function menustate:spawnbullet(name, x, y, vx, vy)
  local b = bullet.new(name, x, y, vx, vy)
  table.insert(self.bullets, b)
  return b
end

function menustate:spawnbulletangular(name, x, y, theta, m)
  local xv = math.cos(theta) * m
  local yv = math.sin(theta) * m
  return self:spawnbullet(name, x, y, xv, yv)
end

function menustate:update(dt)
  self.counter = self.counter + 1
  self.accumulator = self.accumulator + 1

  if self.counter >= 5 then
    for i = -7,7 do
      local b = self:spawnbulletangular('bullet-b', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2+200, 3*math.pi/2 + i * math.pi / 4 + self.accumulator*math.pi/256, 5)
      b.life = 90
      b.accelmag = 0.5
      b.accelangle = math.pi / 2
    end
    self.counter = 0
  end

  for i = #self.bullets,1,-1 do
    local b = self.bullets[i]
    b.life = b.life - 1
    b:update(dt)
    local bx, by = unpack(b.p)
    if b.life <= 0 then
      b:kill()
    end
    if not self.bulletzone:contains(unpack(b.p)) then
      b:kill()
    end
    if not b.alive then
      table.remove(self.bullets, i)
    end
  end
end


function menustate:keypressed(key)
  if key == 'return' then
    self:sm():push(playstate.new())
  end

  if key == 'escape' then
    love.event.quit()
  end
end

function menustate:draw(a)
  local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

  love.graphics.setColor(20/255, 12/255, 28/255)
  love.graphics.rectangle('fill', 0, 0, sw, sh)

  love.graphics.setColor(1, 1, 1)

  for i = 1,#self.bullets do
    self.bullets[i]:draw(a)
  end

  love.graphics.setFont(titlefont)
  do
    local t = 'Rocket Rabbit'
    local tw = titlefont:getWidth(t)
    local th = titlefont:getHeight()
    love.graphics.print(t, sw / 2 - tw / 2, sh / 2 - th / 2 - 200)
  end

  love.graphics.setFont(font)
  do
    local tw = font:getWidth('Press ENTER to begin')
    local th = font:getHeight()
    love.graphics.print('Press ENTER to begin', sw / 2 - tw / 2, sh / 2 - th / 2)
  end
end

return menustate

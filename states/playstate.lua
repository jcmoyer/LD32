local module = require('hug.module')
local gamestate = require('hug.gamestate')
local stage = require('game.stage')
local stagedsl = require('game.stagedsl')
local sound = require('game.sound')
local gameoverstate = require('states.gameoverstate')
local pausestate = require('states.pausestate')

local playstate = module.new(gamestate)

local ui = love.graphics.newImage('assets/ui.png')
local rabbit = love.graphics.newImage('assets/rabbit.png')

local font = love.graphics.newFont(14)

function playstate.new()
  local instance = {
    stage = nil
  }
  return setmetatable(instance, playstate)
end

function playstate:enter(oldstate)
  if not pausestate.type(oldstate) then
    local chunk = love.filesystem.load('data/levels/level01.lua')
    self.stage = stagedsl.run(chunk)
    self.stage:startlevel()
  end
end

function playstate:leave(newstate)
  if not pausestate.type(newstate) then
    self.stage:stopmusic()
  end
end

function playstate:keypressed(key)
  if key == 'escape' then
    self:sm():push(pausestate.new())
  end
end

function playstate:update(dt)
  if self.stage.gameover then
    self:sm():pop()
    self:sm():push(gameoverstate.new(self.stage.win, self.stage.score))
    return
  end

  local xv, yv = 0, 0
  local xmove, ymove = false, false

  local player = self.stage.player
  if love.keyboard.isDown('left') then
    xv = xv - player:speed()
    xmove = true
  end
  if love.keyboard.isDown('right') then
    xv = xv + player:speed()
    xmove = true
  end

  if love.keyboard.isDown('up') then
    yv = yv - player:speed()
    ymove = true
  end
  if love.keyboard.isDown('down') then
    yv = yv + player:speed()
    ymove = true
  end

  if love.keyboard.isDown('z') then
    -- FIRE THE CARROTS
    if self.stage:spawnplayerbullet() then
      sound.play('shoot')
    end
  end

  self.stage.player:setfocus(love.keyboard.isDown('lshift'))

  if xmove then
    self.stage.player.v[1] = xv
  else
    self.stage.player.v[1] = 0
  end
  if ymove then
    self.stage.player.v[2] = yv
  else
    self.stage.player.v[2] = 0
  end

  --self.stage:spawnbullet(300, 200, 10 * (math.random() - math.random()), math.random() * 10)
  self.stage:update(dt)
end

function playstate:draw(a)
  -- display dimensions
  local dw, dh = love.graphics.getWidth(), love.graphics.getHeight()

  local sx, sy = self.stage:screenpos(dw, dh)

  love.graphics.setColor(1, 1, 1)
  self.stage:draw(a)

  love.graphics.draw(ui, 0, 0)

  local lives = self.stage.lives

  local basex, basey = 905, 59
  for i = 0,(lives-1) do
    love.graphics.draw(rabbit, basex + i * (rabbit:getWidth() + 2), basey)
  end

  love.graphics.setFont(font)
  love.graphics.print(self.stage.score, 905, 35)

  --905,59

  --love.graphics.setColor(50, 0, 0)
  --love.graphics.rectangle('fill', 0, 0, sx, dh)

  --local stager = sx + self.stage.bounds[3]
  --love.graphics.rectangle('fill', stager, 0, dw - stager, dh)

  --love.graphics.rectangle('fill', sx, 0, self.stage.bounds[3], sy)

  --local stageb = sy + self.stage.bounds[4]
  --love.graphics.rectangle('fill', sx, stageb, self.stage.bounds[3], dh - stageb)
end

return playstate

local module = require('hug.module')

local music = module.new()

local tracks = {
  level01 = {
    start = love.audio.newSource('assets/level01-intro.ogg'),
    loop = love.audio.newSource('assets/level01-loop.ogg')
  },
  boss = {
    start = love.audio.newSource('assets/boss-intro.ogg'),
    loop = love.audio.newSource('assets/boss-loop.ogg')
  }
}

function music.new(name)
  local track = tracks[name]
  track.loop:setLooping(true)
  local instance = {
    started = false,
    inloop = false,
    track = track
  }
  return setmetatable(instance, music)
end

function music:start()
  self.started = true
  self.inloop = false
  self.track.start:stop()
  self.track.loop:stop()
  self.track.start:play()
end

function music:stop()
  self.started = false
  self.inloop = false
  self.track.start:stop()
  self.track.loop:stop()
end

function music:update()
  if (self.track.start:isStopped() and self.started and not self.inloop) then
    self.track.loop:play()
    self.inloop = true
  end
end

function music:restart()
  self.started = true
  self.inloop = false
  self.track.start:stop()
  self.track.loop:stop()
  self.track.start:play()
end

return music

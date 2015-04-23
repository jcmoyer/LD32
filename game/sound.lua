local sound = {}

local sounds = {
  pop = love.audio.newSource('assets/pop.ogg', 'static'),
  pop2 = love.audio.newSource('assets/pop2.ogg', 'static'),
  shoot = love.audio.newSource('assets/shoot.ogg', 'static'),
  hit = love.audio.newSource('assets/hit.ogg', 'static'),

  multishot = love.audio.newSource('assets/multifire.ogg', 'static')
}

function sound.play(name)
  love.audio.stop(sounds[name])
  love.audio.play(sounds[name])
end

return sound

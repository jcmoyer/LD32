local stage = require('game.stage')

local stagedsl = {}

function stagedsl.run(f)
  local spawns = {}

  local function enemy(name, frame, x, y, userdata)
    table.insert(spawns, {frame = frame, name = name, x = x, y = y, spawned = false, userdata = userdata})
  end

  local env = {
    enemy = enemy,
    spawnzone = stage.spawnzone,
    math = math
  }

  setfenv(f, env)
  f()
  
  return stage.new(spawns, env.music)
end

return stagedsl

local adsl = require('hug.anim.dsl')
local imagecache = require('game.imagecache')
local animutil = require('game.animutil')

local eis = {}

function eis.filename(enemyname)
  return 'data/enemies/' .. enemyname .. '.lua'
end

function eis.runfile(filename)
  return eis.run(love.filesystem.load(filename))
end

function eis.run(f)
  local aset

  local function asetf(fun)
    aset = adsl.run(fun)
  end

  -- after env is filled we expect image, spawn, and update fields
  local env = {
    aset = asetf,
    math = math,
    table = table
  }

  setfenv(f, env)
  f()

  if env.image then
    env.image = imagecache:get(env.image)
  end
  env.aset = aset
  env.hp = env.hp or 1
  if aset then
    animutil.genfquads(aset, env.image)
  end

  return env
end

return eis

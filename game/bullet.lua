local module = require('hug.module')
local vector2 = require('hug.vector2')
local animator = require('hug.anim.animator')
local adsl = require('hug.anim.dsl')
local animutil = require('game.animutil')

local bullet = module.new()
local spritesheet = love.graphics.newImage('assets/bullets.png')

local aset = adsl.run(function()
  animation 'bullet-a' {
    frame {
      source = rectangle(0, 0, 16, 16),
      -- hacky way to store bullet radius
      attachment('radius', 8, 0)
    }
  }

  animation 'bullet-b' {
    frame {
      source = rectangle(0, 16, 16, 16),
      attachment('radius', 4)
    }
  }

  animation 'bullet-b-red-huge' {
    frame {
      source = rectangle(80, 0, 32, 32),
      attachment('radius', 5)
    }
  }

  animation 'bullet-b-red' {
    frame {
      source = rectangle(32, 16, 16, 16),
      attachment('radius', 4)
    }
  }

  animation 'flame' {
    frame {
      source = rectangle(0, 64, 16, 16),
      attachment('radius', 8),
      duration = '50ms'
    },
    frame {
      source = rectangle(16, 64, 16, 16),
      attachment('radius', 8),
      duration = '50ms'
    }
  }

  animation 'bullet-a-huge' {
    frame {
      source = rectangle(192, 0, 32, 32),
      attachment('radius', 8)
    }
  }

  animation 'bullet-c' {
    frame {
      source = rectangle(0, 32, 16, 16), duration = '50ms',
      attachment('radius', 4, 0)
    },
    frame {
      source = rectangle(16, 32, 16, 16), duration = '50ms',
      attachment('radius', 4, 0)
    },
    frame {
      source = rectangle(32, 32, 16, 16), duration = '50ms',
      attachment('radius', 4, 0)
    },
    frame {
      source = rectangle(48, 32, 16, 16), duration = '50ms',
      attachment('radius', 4, 0)
    },
  }

  animation 'carrot' {
    --frame {
    --  source = rectangle(0, 256-32, 16, 32), duration = '50ms',
    --  attachment('radius', 0, 0)
    --},
    --frame {
    --  source = rectangle(16, 256-32, 16, 32), duration = '50ms',
    --  attachment('radius', 0, 0)
    --}
    frame {
      source = rectangle(0, 256-32, 32, 16), duration = '50ms',
      attachment('radius', 0, 0)
    },
    frame {
      source = rectangle(0, 256-16, 32, 16), duration = '50ms',
      attachment('radius', 0, 0)
    }
  }
end)
animutil.genfquads(aset, spritesheet)

function bullet.new(name, x, y, vx, vy)
  local instance = {
    alive = true,
    -- pos and velocity
    p = vector2.new(x, y),
    v = vector2.new(vx, vy),
    -- angular acceleration
    accelangle = 0,
    accelmag = 0,
    -- preallocate vector for prediction to keep pressure off GC
    predictvec = vector2.new(),
    -- animation state
    anim = animator.new(aset)
  }
  instance.anim:play(name)--('carrot')--('bullet-c')
  return setmetatable(instance, bullet)
end

function bullet:update(dt)
  self.anim:update(dt)

  -- angular acceleration
  local direction = self:direction()
  direction = direction + self.accelangle
  self.v:add(
    math.cos(direction) * self.accelmag,
    math.sin(direction) * self.accelmag)

  self.p:add(self.v)
end

function bullet:predict(a)
  self.predictvec:set(
    self.p[1],
    self.p[2])
  self.predictvec:add(
    self.v[1] * a,
    self.v[2] * a)

  return self.predictvec
end

function bullet:draw(a)
  local rx, ry = unpack(self:predict(a))
  rx = math.floor(rx)
  ry = math.floor(ry)
  local f = self.anim:frame()
  love.graphics.draw(spritesheet, f.quad, rx, ry,
    self:direction(), 1, 1, f:width() / 2, f:height() / 2)

  --local r = f:attachment('radius')[1]
  --love.graphics.setColor(255,0,0)
  --love.graphics.circle('fill', rx, ry, r)
  --love.graphics.setColor(255,255,255)
end

function bullet:kill()
  self.alive = false
end

function bullet:direction()
  return math.atan2(self.v[2], self.v[1])
end

function bullet:radius()
  return self.anim:frame():attachment('radius')[1]
end

return bullet

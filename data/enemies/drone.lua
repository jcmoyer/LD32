image = 'assets/drone.png'
hp = 3

aset(function()
  animation 'default' {
    frame {
      source = rectangle(0, 0, 32, 32), duration = '70ms',
      attachment('radius', 16, 0)
    },
    frame {
      source = rectangle(32, 0, 32, 32), duration = '70ms',
      attachment('radius', 16, 0)
    },
    frame {
      source = rectangle(0, 32, 32, 32), duration = '70ms',
      attachment('radius', 16, 0)
    },
    frame {
      source = rectangle(32, 32, 32, 32), duration = '70ms',
      attachment('radius', 16, 0)
    }
  }
end)

local ticks = 0
local fires = false
local fireticks = 10

function spawn(context, userdata)
  local vx = userdata.vx or 0
  local vy = userdata.vy or 0

  local aa = userdata.aa or 0
  local am = userdata.am or 0

  context:setv(vx, vy)
  context:seta(aa, am)

  fires = userdata.fires or fires
  fireticks = userdata.fireticks or fireticks
end

function update(context)
  if not context:onscreen() then
    return
  end
  if fires then
    ticks = ticks + 1
    if ticks >= fireticks then
      local r = context:angletoplayer()
      context:spawnbulletangular('bullet-c', r, 5)
      context:playsound('multishot')
      ticks = 0
    end
  end
end



music = 'boss'

enemy('platform', 0, spawnzone('xcenter'), spawnzone('top'), {vy=1,fires=true})

for i = 1,5 do
  enemy('drone', i * 10, spawnzone('left'), spawnzone('ycenter')-200, {vx=5, fires=true})
  enemy('drone', i * 10, spawnzone('right'), spawnzone('ycenter')-200, {vx=-5, fires= true})
end

for i = 1,5 do
  enemy('drone', 300 + i * 10, spawnzone('xcenter')-100, spawnzone('top'), {vy=7, fires=true,aa=math.pi/2, am=0.04})
  enemy('drone', 300 + i * 10, spawnzone('xcenter')+100, spawnzone('top'), {vy=7, fires= true,aa=-math.pi/2, am=0.04})
end

enemy('blade', 500, spawnzone('xcenter'), spawnzone('top'))
enemy('blade', 525, spawnzone('xcenter')-100, spawnzone('top'))
enemy('blade', 550, spawnzone('xcenter')+100, spawnzone('top'))
enemy('blade', 575, spawnzone('xcenter')-200, spawnzone('top'))
enemy('blade', 600, spawnzone('xcenter')+200, spawnzone('top'))

for i = 1,6 do
  enemy('drone', 600 + (i - 1) * 10, spawnzone('xcenter')-200, spawnzone('top'), {vy=7, fires=true})
end
for i = 1,6 do
  enemy('drone', 650 + (i - 1) * 10, spawnzone('xcenter')+200, spawnzone('top'), {vy=7, fires=true})
end


enemy('blade', 650, spawnzone('left'), spawnzone('ycenter')-200)
enemy('blade', 650, spawnzone('right'), spawnzone('ycenter')-200)


enemy('blade', 800, spawnzone('left'), spawnzone('top'))
enemy('blade', 800, spawnzone('right'), spawnzone('top'))
enemy('platform', 750, spawnzone('xcenter')-100, spawnzone('top'), {vy=3,fires=true})
enemy('platform', 780, spawnzone('xcenter')+100, spawnzone('top'), {vy=3,fires=true})

local curyscrollv = 1
for i = 1,20 do
  curyscrollv = curyscrollv + 1
  enemy('scrolldummy', 900 + (i - 1) * 10, 0, 0, {yv = curyscrollv})
end
for i = 1,10 do
  for j = -3,3 do
    enemy('drone', 900 + (i - 1) * 10, spawnzone('xcenter')+100*j, spawnzone('top'), {vy=5})
  end
end
for i = 1,10 do
  for j = -3,3 do
    enemy('drone', 960 + (i - 1) * 10, spawnzone('left'), spawnzone('ycenter')+100*j, {vx=5})
  end
end
for i = 1,10 do
  for j = -3,3 do
    enemy('drone', 1010 + (i - 1) * 10, spawnzone('right'), 50+spawnzone('ycenter')+100*j, {vx=-5})
  end
end

enemy('blade', 1080, spawnzone('left'), spawnzone('bottom'))
enemy('blade', 1080, spawnzone('right'), spawnzone('bottom'))

enemy('metaleye', 1250, spawnzone('xcenter'), spawnzone('top'))

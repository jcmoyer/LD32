local animutil = {}

-- generates quads per frame and stores them in the frame as 'quad'
function animutil.genfquads(aset, image)
  for i = 1,#aset.animations do
    local a = aset.animations[i]
    for j = 1,#a.frames do
      local f = a.frames[j]
      f.quad = love.graphics.newQuad(
        f[1],
        f[2],
        f[3],
        f[4],
        image:getWidth(),
        image:getHeight())
    end
  end
end

return animutil

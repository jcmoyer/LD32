local flashshader = {}

local shader = love.graphics.newShader [[
extern float flash;

vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord) {
    vec4 outputcolor = Texel(tex, texcoord) * vcolor;
    outputcolor.r = outputcolor.r + flash * (222 * flash - outputcolor.r);
    outputcolor.g = outputcolor.g + flash * (238 * flash - outputcolor.g);
    outputcolor.b = outputcolor.b + flash * (214 * flash - outputcolor.b);
    return outputcolor;
}
]]

function flashshader.setflash(value)
  if value then
    value = 1
  else
    value = 0
  end
  shader:send('flash', value)
end

function flashshader.enable(status)
  if status then
    love.graphics.setShader(shader)
  else
    love.graphics.setShader()
  end
end

return flashshader

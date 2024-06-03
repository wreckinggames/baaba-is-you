local pixel = love.graphics.newImage("sprite/pixel.png")
function drawborders()
  local i = 0
  local j = 1
  love.graphics.setColor(palettecolors[7][4])
  local csprite = pixel
  while i < levelx do
    love.graphics.draw(csprite,i*tilesize + x_offset,0  + y_offset,0,tilesize / 24)
    i = i + 1
  end
  while j < levely do
    love.graphics.draw(csprite,0  + x_offset,j*tilesize  + y_offset,0,tilesize / 24)
    j = j + 1
  end
  i = 0
  j = 0
  while i < levelx do
    love.graphics.draw(csprite,i*tilesize  + x_offset,levely*tilesize  + y_offset,0,tilesize / 24)
    i = i + 1
  end
  while j < levely do
    love.graphics.draw(csprite,(levelx-1)*tilesize  + x_offset,j*tilesize  + y_offset,0,tilesize / 24)
    j = j + 1
  end
  local dx, dy = (levelx-1)*tilesize  + x_offset + tilesize, levely*tilesize  + y_offset + tilesize

  local width, height = love.graphics.getDimensions()
  love.graphics.rectangle("fill", dx, 0, width, height)
  love.graphics.rectangle("fill", 0, dy, width, height)

  love.graphics.rectangle("fill", 0, 0, width, y_offset)
  love.graphics.rectangle("fill", 0, 0, x_offset, height)
end

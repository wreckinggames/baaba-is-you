Palleteimage = love.image.newImageData("sprite/testpalette.png")
palettecolors = {}
for eye = 0,6 do--Palleteimage:getHeight()-1 do
  local tempcolors = {}
  for eyee = 0,4 do--Palleteimage:getWidth()-1 do
    local a,b,c = Palleteimage:getPixel(eye,eyee)

    table.insert(tempcolors,{a,b,c})
  end
  table.insert(palettecolors,tempcolors)
end

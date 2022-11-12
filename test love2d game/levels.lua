love.filesystem.load("values.lua")()
function saveleveldata(getlvlname)
  local tempObjects = ""
  local temp2 = ""
  for gg,hh in ipairs(Objects) do
  tempObjects = "{\nNAME:" .. hh.name .. "\nXPOS:" .. tostring(hh.x) .. "\nYPOS:" .. tostring(hh.y) .. "\n}\n"
  temp2 = temp2 .. tempObjects
    love.filesystem.write(getlvlname,temp2)
    love.filesystem.read(getlvlname)
  end
  love.graphics.setColor(1,1,1)
end

function loadlevel(lvlnamee)
  local objxs = 0
  local objys = 0
  local objnames = ""
  for objdata in love.filesystem.lines(lvlnamee) do
  if not(objdata == "{") then
    if not(objdata == "}") then
     if (string.sub(objdata,1,5)== "NAME:") then
      objnames = string.sub(objdata,6,string.len(objdata))
     end
     if (string.sub(objdata,1,5) == "XPOS:") then
      objxs = string.sub(objdata,6,string.len(objdata))
     end
     if (string.sub(objdata,1,5) == "YPOS:") then
      objys = string.sub(objdata,6,string.len(objdata))
     end
      to = objxs
    else

   makeobject(objxs / tilesize, objys / tilesize, objnames, 0, 0)
  end
end
end
end

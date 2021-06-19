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
   ob = {}
   ob.getnumber = math.random(0,100)
   ob.size = 1.231;
   ob.x = tonumber(objxs)
   ob.y = tonumber(objys)
   ob.tilex = math.floor(ob.x/tilesize)
   ob.tiley = math.floor(ob.y/tilesize)
   ob.dir = 0
   ob.meta = 0
   ob.id = #Objects + 1
   ob.transformable = true
      ob.name = objnames
         ob.sprite = ob.name
   if (string.sub(objnames,1,10) == "text_text_")then
   ob.sprite = string.sub(objnames,6,string.len(objnames))
       ob.meta = 1
   end
   ob.rule = {}
   ob.color = getspritevalues(ob.sprite).color
   ob.active = true
   table.insert(Objects,ob)
  end
end
end
end

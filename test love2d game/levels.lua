love.filesystem.load("values.lua")()
function saveleveldata(getlvlname)
  local tempObjects = ""
  local temp2 = "PALETTE:" .. palette .. "\nSIZE_X:" .. tostring(levelx) .. "\nSIZE_Y:" .. tostring(levely) .. "\nMUSIC:" .. tostring(levelmusic) .. "\n"
  for gg,hh in ipairs(editor_curr_objects) do
  tempObjects = "{\nNAME:" .. hh.name .. "\nXPOS:" .. tostring(hh.tilex) .. "\nYPOS:" .. tostring(hh.tiley) .. "\nDIR:" .. tostring(hh.dir) .. "\n}\n"
  temp2 = temp2 .. tempObjects
    love.filesystem.write(getlvlname,temp2)
    --love.filesystem.read(getlvlname)
  end
  love.graphics.setColor(1,1,1)
end
function loadleveldata(levelnamee)

    editor_curr_objects = {}
    local objxs = 0
    local objys = 0
    local objnames = ""
    local objdirs = "right"

    for objdata in love.filesystem.lines(levelnamee) do

      objdirs = "right"
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
       if (string.sub(objdata,1,4) == "DIR:") then
        objdirs = string.sub(objdata,5,string.len(objdata))
       end
       if string.sub(objdata,1,8) == "PALETTE:" then
         for m, n in ipairs(all_palettes) do
           if n == string.sub(objdata,9) then
             palette_id = m
             loadPalette(all_palettes[palette_id])
             initui()
             break
           end
         end
       end
       if string.sub(objdata,1,7) == "SIZE_X:" then
         levelx = tonumber(string.sub(objdata,8))
       end
       if string.sub(objdata,1,7) == "SIZE_Y:" then
         levely = tonumber(string.sub(objdata,8))
       end
       if string.sub(objdata,1,6) == "MUSIC:" then
         levelmusic = tonumber(string.sub(objdata,7))
         playmusic(musiclist[levelmusic])
       end
      else
     addobject(objnames, tonumber(objxs), tonumber(objys), objdirs)
    end
  end
  end
end

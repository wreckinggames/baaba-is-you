love.filesystem.load("values.lua")()
function saveleveldata(getlvlname)

  local tempObjects = ""
  local temp2 = "PALETTE:" .. palette .. "\nSIZE_X:" .. tostring(levelx) .. "\nSIZE_Y:" .. tostring(levely) .. "\nMUSIC:" .. tostring(levelmusic) .. "\n"
  for gg,hh in ipairs(editor_curr_objects) do
    local li = ""
    if hh.levelinside ~= nil then
      li = "\nLEVEL:" .. hh.levelinside
    end
  tempObjects = "{\nNAME:" .. hh.name .. "\nXPOS:" .. tostring(hh.tilex) .. "\nYPOS:" .. tostring(hh.tiley) .. "\nDIR:" .. tostring(hh.dir) .. li .. "\n}\n"
  temp2 = temp2 .. tempObjects
    love.filesystem.write("levels/"..getlvlname,temp2)
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
    local objlevels = nil
    local objnums = nil
    local objlocks = nil
    if not love.filesystem.getInfo("levels/"..levelnamee) then
      return
    end

    for objdata in love.filesystem.lines("levels/"..levelnamee) do

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
       if (string.sub(objdata,1,6) == "LEVEL:") then
        objlevels = string.sub(objdata,7,string.len(objdata))
       end
       if (string.sub(objdata,1,4) == "NUM:") then
        objnums = string.sub(objdata,5,string.len(objdata))
       end
       if (string.sub(objdata,1,5) == "LOCK:") then
        objlocks = string.sub(objdata,6,string.len(objdata))
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

     addobject(objnames, tonumber(objxs), tonumber(objys), objdirs, objlevels)
      editor_curr_objects[#editor_curr_objects].num = objnums
      if objlocks ~= nil then
        editor_curr_objects[#editor_curr_objects].lock = objlocks
      end
     objlevels = nil
     objnums = nil
     objlocks = nil
    end
  end
  end
end


function enterlevel(thelevel)
  table.insert(leveltree, thelevel)
  delete_these_specific_menu_buttons()
  levelname = ""


  dielevel()
  love.timer.sleep(0.1)


  --playmusic("nothing")
  gamestate = "menu"
  menu_state = "main"
  editor_curr_objects = {}

  gotogame()
  levelname = thelevel
  --oh my god this code is so jank what the hE{"1": {1, 3, 56, 2, 56}}

  dolevelload()
  love.timer.sleep(0.2)
  loadlevel()
  gotogame()
  --playmusic(musiclist[levelmusic])
  delete_these_specific_menu_buttons()

  x_offset = (love.graphics.getWidth() - levelx * tilesize) / 2
  y_offset = (love.graphics.getHeight() - (levely + 1) * tilesize) / 2
end


function levelcompleted(l)
  if (love.filesystem.getInfo("progress/levels.txt") == nil) then
    return false
  end

  for objdata in love.filesystem.lines("progress/levels.txt") do
    if string.sub(objdata,1,8) == "cleared=" and string.sub(objdata, 9) == l then
      return true
    end

  end

  return false

end

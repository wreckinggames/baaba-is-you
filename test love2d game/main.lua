love.filesystem.load("border.lua")()

AllLevels = {}
rules = {}
active = false

local enabledebug = false
 winning = false
 local redraw_objects = true
function love.load()

  --love.audio.play(love.audio.newSource("sound/baaba.wav","static"))


  levelx = 33
  levely = 17
   love.graphics.setDefaultFilter("nearest", "nearest", 1)
  DBG = ""
  draw = true
  done = false
  move = false
  writethese = {}
  hideui = true
  Palleteimage = love.graphics.newImage("sprite/testpalette.png")
  --leveldata = "testaaa={"
  heldtile = ""
  changedicon = {"",false}
  to = false
  tilesize = 24
  changecolor = {0.5,0.5,0.5}
 Objects = {}
 ingroup = {}
 MovingObjects = {}
 rules = {}
 currenticon = "baaba"
 changeicon = love.window.setIcon(love.image.newImageData("sprite/baaba-right.png"))
 keys = {"a","d","w","s","space","left","right","up","down"}
images=
{{"baaba","stone","tiles","text_tiles","text_baaba","text_stone","text_is","text_you","text_meta","text_this","text_red","text_all","text_text","text_move","text_push","text_icon","text_weak","text_open","text_shut","text_stop","keeke","flag","wall"},{"text_keeke","text_flag","text_wall","whater","text_whater","text_sink","lavaaa","text_lavaaa","text_hot","text_melt","text_fofofo","fofofo","text_key","key","text_door","door","text_group","clock","text_clock","text_have","text_win","text_defeat",
"text_clipboard"},{"text_orange","text_skulll","skulll","leevel","text_leevel","text_icy","icy","text_what","pumpkin","text_pumpkin","text_n'", "text_lonely","jelly","text_jelly", "text_often", "text_seldom", "text_powered", "text_power", "text_on", "box", "text_box", "bug","text_bug"},
{ "square", "text_square",
 "circle", "text_circle", "triangle", "text_triangle", "text_fear","grass","text_grass","grubble","text_grubble","rubble","text_rubble", "scribble", "text_scribble","hex","text_hex","pentagon","text_pentagon","text_float", "cake","text_cake","the m"},{"text_the m", "jijiji",
 "text_jijiji","no","text_no","text_small","crab","text_crab","robot","text_robot","brick","text_brick","hedge","text_hedge","block","text_block","pa","text_pa","belt","text_belt","fungus","text_fungus","bubble"},{"text_bubble","pillar","text_pillar","flower","text_flower","algae","text_algae","love",
 "text_love","star","text_star","baadbad","text_baadbad","bolt","text_bolt","cog","text_cog","foliage","text_foliage","fruit","text_fruit","ghost","text_ghost"},{"husk","text_husk","leaf","text_leaf","pipe","text_pipe","reed","text_reed","statue","text_statue","tree","text_tree","text_active","text_place","text_placed","text_goal","text_target","goal","target","button","text_button","text_bird","bird"},{"bat",
   "text_bat","sun","text_sun","cliff","text_cliff","fence","text_fence","rose","text_rose","cloud","text_cloud","rocket","text_rocket","dust","text_dust", "text_up", "text_yellow", "text_gellow", "text_green", "text_blue", "text_purple"
 } }
require "ui"
require "tool"
require "values"
require "rules"
require "block"
require "move"
require "levels"
require "palette"
require "editor"

baserules = {}

table.insert(baserules,{"text","is","push"})
table.insert(baserules,{"leevel","is","stop"})
love.keyboard.setKeyRepeat(true)
end


function passturn()

  active = false

   for i,unit in ipairs(Objects) do
     if(getspritevalues(unit.name).rotate == 4) and type(unit.dir) == "string" then
       unit.sprite =  unit.name .. "-" .. unit.dir
       unit.color = getspritevalues(unit.name).color
     end
     unit.tilex = math.floor(unit.x/tilesize)
     unit.tiley = math.floor(unit.y/tilesize)
     unit.small = 1
   end

   local issmall = objectswithproperty("small")
   for i,c in ipairs(issmall) do
     c.small = c.small / 2
     c.size = c.size / 2
   end


   active = true

   local isplace = objectswithproperty("place")

   for i, j in ipairs(isplace) do
     local onj = on(j)
     local thisfailed = true
     for k, l in ipairs(onj) do
       if ruleexists(l.id,nil,"is","placed") then
         thisfailed = false
       end
     end
     if thisfailed then
       active = false
       break
     end
   end

    testmove()
    rules = {}
    Parser:init()
    Parser:makeFirstWords()
    Parser:MakeRules()
    Parser:ParseRules()
    rules = {}
    for i,b in ipairs(baserules) do
      table.insert(rules,b)
    end
    Parser:AddRules()
    -- oh boy debugging
    -- Parser:Debug()

    for i, j in ipairs(Objects) do
      j.small = 1
    end
    local issmall = objectswithproperty("small")
    for i,c in ipairs(issmall) do
      c.small = c.small / 2
    end

    ingroup = {}
    local groups = objectswithproperty("group")
    for i,group in ipairs(groups) do
      if ingroup[group.id] then
        table.insert(ingroup[group.id], "group")
      else
        ingroup[group.id] = {"group"}
      end
    end

    findproperties()
end

candoturn = false

function love.keypressed(key, scancode, isrepeat)
--function love.update(key, scancode, isrepeat)

if(editlevelname == false)then
  if(key == "x")then
 saveleveldata(levelname)
  end
  if(key == "l")then
   Objects = {}
 loadlevel(levelname)
  end
  if(key == "j")then
   Objects = {}
 loadlevel("maingame/baaba is you.leevel")
  end
  if key == "p" then
    DBG = palette
    if palette == "testpalette" then
      loadPalette("brighter")
    elseif palette == "brighter" then
      loadPalette("AAAAA")
    elseif palette == "AAAAA" then
      loadPalette("table")
    elseif palette == "table" then
      loadPalette("testpalette")
    end
  end
  if key == "tab" then
    hideui = not hideui
  end candoturn = true
  if ineditor then
    if key == "=" then
      levelx = levelx + 1
      levely = levely + 1
    end
    if key == "-" then
      levelx = levelx - 1
      levely = levely - 1
    end
    if key == "s" then
      levely = levely + 1
    end
    if key == "w" then
      levely = levely - 1
    end
    if key == "a" then
      levelx = levelx - 1
    end
    if key == "d" then
      levelx = levelx + 1
    end
    if (key == "-" or key == "w" or key == "a") then
      --didnt work
    end

  end

end

end
function love.draw()
  if not love.window.hasFocus() then
    return
  end

drawborders()




 for i,c in ipairs(Objects) do
   if(getspritevalues(c.name).rotate == 4) and type(c.dir) == "string" then
    c.sprite =  c.name .. "-" .. c.dir
    if(c.customcolor == false)then
     c.color = getspritevalues(c.name).color
    end
   end
   local t = palettecolors[c.color[1]]
   if(t ~= nil) and (t[c.color[2]] ~= nil)then
    love.graphics.setColor(t[c.color[2]])
      if c._active == false then
        local a1 = { t[c.color[2]][1] * 0.5, t[c.color[2]][2] * 0.5, t[c.color[2]][3] * 0.5}
        love.graphics.setColor(a1)
      end
    end
    love.graphics.setBackgroundColor(palettecolors[1][5])
    if(c.active == true)then

      local cx = c.x
      local cy = c.y
      if c.size < 1 then
        cx = cx + 6
        cy = cy + 12
      end


        local csprite = nil
        if string.sub(c.sprite,1,10) == "text_text_" then
          csprite = love.graphics.newImage("sprite/" .. string.sub(c.sprite,6,-1) .. ".png")
        else
          csprite = love.graphics.newImage("sprite/" .. c.sprite .. ".png")
        end
        love.graphics.draw(csprite,cx,cy,0,c.size)--love.graphics.draw(love.graphics.newImage("sprite/" .. c.sprite .. ".png") or love.graphics.newImage("sprite/error.png"),c.x,c.y,0,c.size)

      love.graphics.setColor(1,1,1)
    end
  --love.graphics.print(c.rule[1] or "",c.x,c.y)
  --love.graphics.print(c.meta,c.x+c.size*15,c.y+c.size*15)
--  love.graphics.print(math.floor(dist(c.x+c.size/2,c.y+c.size/2,love.mouse.getX(),love.mouse.getY())),c.x+c.size/4,c.y+10)
    love.graphics.setColor(1,0,0)
--love.graphics.print()
    if string.sub(c.sprite,1,10) == "text_text_" then
      love.graphics.setColor(1,0,0.5)
      love.graphics.draw(love.graphics.newImage("sprite/textMeta.png"),c.x,c.y,0,c.size)
    end
   --love.graphics.print(tostring(4),c.x,c.y)
--  love.graphics.print(tostring(to),300,300)
  --string.pack("j",3)
    if c.name == "clock" then
      local hour = os.date("*t",os.time()).hour
      if(tonumber(hour) == 0)then
        hour = "12"
      end
      if(string.len(hour) == 1)then
        hour = "0" .. hour
      end
      if(tonumber(hour) > 12)then
        hour = tostring(tonumber(hour) - 12)
      end
      local min = os.date("*t",os.time()).min
      if(string.len(min) == 1)then
        min = "0" .. min
      end
      if c.size > 0.6 then
        love.graphics.print(hour .. ":" .. min,c.x-3,c.y+tilesize/3+1,0,0.8)
      elseif c.size > 0.3 then
        love.graphics.print(hour .. ":" .. min,c.x+3,c.y+tilesize/3+9,0,0.4)
      elseif c.size > 0.1 then
        love.graphics.print(hour .. ":" .. min,c.x+5,c.y+tilesize/3+6,0,0.2)
      end
    end
 end

 if canwin() then
   love.graphics.setColor(1,1,1)
  love.graphics.draw(love.graphics.newImage("graphics/you win.png"),300,300,0,1)
 end


 draweditor()

      if  not hideui and ineditor then
        drawui()
      end


        love.graphics.setColor(1,0,0)
         love.graphics.print(current_textinput,0,300)

         --DBG = love.timer.getFPS()
         --love.graphics.print(DBG,0,300)




      --[[   love.graphics.setColor(1,0.5,0.2)
         local aa = ""
         local files = love.filesystem.getDirectoryItems("sprite")
         for k, file in ipairs(files) do
           aa = aa .. k .. ". " .. file .. "\n"

         end
         love.graphics.print(aa)]] --outputs something like "1. main.lua"

         -- Draw Editor Play button
         if ineditor then
           local csprite = love.graphics.newImage("graphics/playbutton.png")
           love.graphics.setColor(palettecolors[4][1])
           love.graphics.draw(csprite,730,530,0,2)
         else
           local csprite = love.graphics.newImage("sprite/flag.png")
           love.graphics.setColor(palettecolors[1][1])
           love.graphics.draw(csprite,730,530,0,2)
         end

end



function love.update(delta)
  if not love.window.hasFocus() then
    return
  end
  if candoturn then
    if newturn() then
      passturn()
    end
    candoturn = false
  end

  handletilething()
end
function dist(xa,ya,xb,yb)
return math.sqrt((yb-ya)^2+(xb-xa)^2)
end
function love.mousepressed(x, y, button, isTouch)
  if x > 740 and y > 520 and x < 800 and y < 580 then
    if ineditor then
      loadlevel()
    else
      dielevel()
    end
  end

  if not ineditor then
        for i, j in ipairs(Objects) do
          if j.tilex == math.floor(love.mouse.getX()/ tilesize ) and j.tiley == math.floor(love.mouse.getY()/ tilesize ) then
            passturn()
          end
        end
  end
end

function makeobject(x,y,name,dir_,meta_)
    obj = {}
    obj.size = 1
    obj.tilex = x
    obj.tiley = y
    obj.x = x*tilesize
    obj.y = y*tilesize
    obj.name = name
        obj.type = getspritevalues(obj.name).type
        obj.color = getspritevalues(obj.name).color
    obj.sprite = obj.name

    obj.dir = dir_ or "right"

    obj.id = #Objects + 1
    obj.transformable = true


    obj.active = true


    table.insert(Objects,obj)
end
function contains(table,item)
for index1,val11 in ipairs(table) do
 if(val11 == item)then
 return true
 end

end
 return false

end
function removeunit(unit)
 for i,j in ipairs(Objects) do
  if(j.id > unit.id)then
   j.id = j.id - 1
  end
 end
  table.remove(Objects,unit.id)
end

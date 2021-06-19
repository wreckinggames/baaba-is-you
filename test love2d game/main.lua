AllLevels = {}
rules = {}
local enabledebug = false
 winning = false
 local redraw_objects = true
function love.load()
  draw = true
  done = false
  move = false
  Palleteimage = love.graphics.newImage("sprite/testpalette.png")
  --leveldata = "testaaa={"
  heldtile = ""
  changedicon = {"",false}
  to = false
  tilesize = 30
  changecolor = {0.5,0.5,0.5}
 Objects = {}
 ingroup = {}
 MovingObjects = {}
 currenticon = ""
 changeicon = love.window.setIcon(love.image.newImageData("sprite/baaba-right.png"))
 keys = {"a","d","w","s","space","left","right","up","down"}
images = {{"baaba","stone","tiles","text_tiles","text_baaba","text_stone","text_is","text_you","text_meta","text_this","text_red","text_all","text_text","text_move","text_push","text_icon","text_weak","text_open","text_shut","text_stop","keeke","flag","wall"},{"text_keeke","text_flag","text_wall","whater","text_whater","text_sink","lavaaa","text_lavaaa","text_hot","text_melt","text_fofofo","fofofo","text_key","key","text_door","door","text_group","clock","text_clock","text_have","text_win","text_defeat","text_clipboard"},{"text_orange","text_skulll","skulll","leevel","text_leevel","text_a","text_b","text_icy","icy","text_up"} }
require "ui"
require "tool"
require "values"
require "rules"
require "block"
require "move"
require "levels"
require "palette"
--new = love.mouse.newCursor("sprite/mouse.png")
-- love.mouse.setCursor(new)
  math.randomseed(5)
 amount = 0
for i = 1,amount+1 do
object = {}
object.size = 1;
object.x = -99
object.y = -99
object.tilex = math.floor(object.x/tilesize)
object.tiley = math.floor(object.y/tilesize)
object.dir = "right"
object.meta = 0
object.transformable = true
object.sprite = "error"
object.id = #Objects + 1
local rnd = math.random(0,60)
object.name = "error"
object.rule = {}
object.color = {math.random(0,100)/100,math.random(0,100)/100,math.random(0,100)/100}
object.active = true
object.type = 0
 table.insert(Objects,object)
end
baserules = {}

table.insert(baserules,{"text","is","push"})
table.insert(baserules,{"leevel","is","stop"})
love.keyboard.setKeyRepeat(true)
end
function love.keypressed(key, scancode, isrepeat)
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
 if newturn() then
 redraw_objects = true
  for i,unit in ipairs(Objects) do
     if(getspritevalues(unit.name).rotate == 4) and type(unit.dir) == "string" then
      unit.sprite =  unit.name .. "-" .. unit.dir
      unit.color = getspritevalues(unit.name).color
     end
    unit.tilex = math.floor(unit.x/tilesize)
    unit.tiley = math.floor(unit.y/tilesize)
  --[[  if(getspritevalues(unit.name).type == 1)then
     local hmm = getrules(math.floor(object.x/tilesize),math.floor(object.y/tilesize),"right")
     if (hmm == {}) then
       hmm = getrules(math.floor(object.x/tilesize),math.floor(object.y/tilesize),"down")
     end
     local doparse = parse(hm)
     if doparse then
       unit.rule = hm
     end
    end
    --]]
  --  findproperties()
    -- testmove()
    unit.rule = {}
    if(getspritevalues(unit.name).type == 1)then--if(unit.name == "text_is")then
      if(gettiles("left",unit.tilex,unit.tiley,1)[1] ~= nil) and (gettiles("right",unit.tilex,unit.tiley,1)[1] ~= nil)then
     local noun = gettiles("left",unit.tilex,unit.tiley,1)[1].name
     local effect = gettiles("right",unit.tilex,unit.tiley,1)[1].name
     if(getspritevalues(noun).type == 5)then
       noun = "text_" .. getletters(unit.tilex,unit.tiley,"left",true)
     end
     if(getspritevalues(effect).type == 5)then
       effect = "text_" .. getletters(unit.tilex,unit.tiley,"right")
     end
     if(istext_or_word(noun) and istext_or_word(effect))then
      unit.rule = {realname(noun),realname(unit.name),realname(effect)}
     end
  elseif(gettiles("up",unit.tilex,unit.tiley,1)[1] ~= nil) and (gettiles("down",unit.tilex,unit.tiley,1)[1] ~= nil)then
     local noun = gettiles("up",unit.tilex,unit.tiley,1)[1].name
     local effect = gettiles("down",unit.tilex,unit.tiley,1)[1].name
     if(getspritevalues(noun).type == 5)then
       noun = "text_" .. getletters(unit.tilex,unit.tiley,"up",true)
     end
     if(getspritevalues(effect).type == 5)then
       effect = "text_" .. getletters(unit.tilex,unit.tiley,"down")
     end
     if(istext_or_word(noun) and istext_or_word(effect))then
      unit.rule = {realname(noun),realname(unit.name),realname(effect)}
     end
    end
    end
  end
  testmove()
  findproperties()
--  testmove()
 end
end
end
function love.draw()




if redraw_objects == true then
      --to = false
 --newalert(100,100,"test",3,{"test2","test3","test4"},{{50,30},{50,30},{50,30}},{80,120})
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
  end
  love.graphics.setBackgroundColor(palettecolors[1][5])
    if(c.active == true)then

      local csprite = love.graphics.newImage("sprite/" .. c.sprite .. ".png")
   love.graphics.draw(csprite,c.x,c.y,0,c.size)--love.graphics.draw(love.graphics.newImage("sprite/" .. c.sprite .. ".png") or love.graphics.newImage("sprite/error.png"),c.x,c.y,0,c.size)
  love.graphics.setColor(1,1,1)
    end
  --love.graphics.print(c.rule[1] or "",c.x,c.y)
  --love.graphics.print(c.meta,c.x+c.size*15,c.y+c.size*15)
--  love.graphics.print(math.floor(dist(c.x+c.size/2,c.y+c.size/2,love.mouse.getX(),love.mouse.getY())),c.x+c.size/4,c.y+10)
love.graphics.setColor(1,0,0)
--love.graphics.print()
  if(c.meta == 1)then
    love.graphics.setColor(1,0,0.5)
  love.graphics.draw(love.graphics.newImage("sprite/textMeta.png"),c.x,c.y,0,c.size)
  end
   --love.graphics.print(tostring(4),c.x,c.y)
  --love.graphics.print(tostring(to),300,300)
  --string.pack("j",3)
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
  if(c.name == "clock")then
   love.graphics.print(hour .. ":" .. min,c.x+3,c.y+tilesize/3+1,0,0.6)
  end
 end

 if canwin() then
   love.graphics.setColor(1,1,1)
  love.graphics.draw(love.graphics.newImage("graphics/you win.png"),300,300,0,1)
 end

    redraw_objects = false
  end
        drawui()
        love.graphics.setColor(1,0,0)
         love.graphics.print(current_textinput,0,300)

      --[[   love.graphics.setColor(1,0.5,0.2)
         local aa = ""
         local files = love.filesystem.getDirectoryItems("sprite")
         for k, file in ipairs(files) do
           aa = aa .. k .. ". " .. file .. "\n"

         end
         love.graphics.print(aa) --outputs something like "1. main.lua"]]
end


function love.mousepressed(x2,y2,button,istouch)

  metaval = 0
 if(button==1) then
  for i2,c in ipairs(buttons) do
   if (dist(love.mouse.getX(),c.buttonsize+c.y1,c.buttonsize+c.x1,love.mouse.getY()) < c.buttonsize*2) then
   heldtile = c.buttonname
   --love.window.setPosition(4,6)
   end
  end
 end
 if(heldtile ~= "")then
 if(button==1) then
  for i6,c in ipairs(buttons) do
    if (dist(love.mouse.getX(),c.buttonsize+c.y1,c.buttonsize+c.x1,love.mouse.getY()) < c.buttonsize*2 )then
    onbutton = true
    end
  end
  if(onbutton==false) then
    if(love.keyboard.isDown("m")) then
    metaval = 1
    end
 getobject()
  end
  onbutton = false
 end
 end
 if(button==2) then
  for i3,c3 in ipairs(buttons) do
   if(dist(c3.x1+50+c3.buttonsize/2,c3.y1+c3.buttonsize/2,love.mouse.getX(),love.mouse.getY()) < c3.buttonsize/1.5) then
  --do function on right click
   end
  end
  for i5,c5 in ipairs(Objects) do
   if(dist(c5.x+tilesize/2,c5.y+tilesize/2,love.mouse.getX(),love.mouse.getY()) < tilesize/1.5) then
   --c5.active = false
    if(love.keyboard.isDown("q") == false)then
     removeunit(c5)
    else
      AllLevels[c5.id] = levelname

    end
   end
  end
 end
 --drawui()


end
function dist(xa,ya,xb,yb)
return math.sqrt((yb-ya)^2+(xb-xa)^2)
end
function getobject()
    obj = {}
    obj.size = 1.231
    obj.x = math.floor(love.mouse.getX()/tilesize)*tilesize
    obj.y = math.floor(love.mouse.getY()/tilesize)*tilesize
    obj.tilex = math.floor(obj.x/tilesize)
    obj.tiley = math.floor(obj.y/tilesize)
    obj.name = heldtile
        obj.type = getspritevalues(obj.name).type
    obj.sprite = obj.name
    obj.color = getspritevalues(obj.name).color
    obj.dir = "right"
    obj.meta = metaval
    obj.id = #Objects + 1
    obj.transformable = true
    if(obj.meta == 1)then
    obj.name = "text_" .. obj.name
    obj.type = 0
    if not(string.sub(obj.name,1,10) == "text_text_")then
    obj.sprite = obj.name
        obj.meta = 0
    end
  end
    obj.rule = {}
    obj.active = true
    table.insert(Objects,obj)
end
function makeobject(x,y,name,dir_,meta_)
    obj = {}
    obj.size = 1.231
    obj.tilex = x
    obj.tiley = y
    obj.x = x*tilesize
    obj.y = y*tilesize
    obj.name = name
        obj.type = getspritevalues(obj.name).type
    obj.sprite = obj.name
    obj.color = getspritevalues(obj.name).color
    obj.dir = dir_ or "right"
    obj.meta = meta_ or 0
    obj.id = #Objects + 1
    obj.transformable = true
    if(obj.meta == 1)then
    obj.name = "text_" .. obj.name
    obj.type = 1
    if not(string.sub(obj.name,1,10) == "text_text_")then
    obj.sprite = obj.name
        obj.meta = 0
    end
  end
    obj.rule = {}
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

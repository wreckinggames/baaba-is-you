love.filesystem.load("rules.lua")()
love.filesystem.load("main.lua")()
  allmoved = {}
function testmove()
  for i,unit in ipairs(Objects) do
    unit.moving = false
  end
  local movers = objectswithproperty("move")
  for i,mover in ipairs(movers) do
   table.insert(allmoved,{mover.id,mover.dir})
  end
  moveunits()
  local stops = objectswithproperty("stop")
  local yous = objectswithproperty("you")
 for youi,younit in ipairs(yous) do
   local d = love.keyboard.isDown
  if(d("w") or d("up"))then table.insert(allmoved,{younit.id,"up"})
elseif(d("a")or d("left"))then table.insert(allmoved,{younit.id,"left"})
elseif(d("s")or d("down"))then table.insert(allmoved,{younit.id,"down"})
elseif(d("d")or d("right"))then table.insert(allmoved,{younit.id,"right"}) end
 end
moveunits()
local pushed = {}
 local ispush = objectswithproperty("push")
for pushi, pushunit in ipairs(ispush) do
  local here = on(pushunit)
  if(#here > 0)then
    for i,there in ipairs(here) do
    if(there.moving)then
   --table.insert(allmoved,{pushunit,here[1].dir})
   --moveunit(allmoved,{pushunit,here[1].dir})
  -- moveunits()
  table.insert(pushed,{pushunit.id,there.dir})
  break
 end
end
 end
end
for i,pushobj in ipairs(pushed) do
   local pushunit = Objects[pushobj[1]]
   --pushunit.color = {1,0,1}
   local pushdir = pushobj[2]
  -- dopush(pushunit.id,pushdir,false)
   local stophere = false
   for j,stopunit in ipairs(stops) do
    if(gettiles(pushdir,pushunit.tilex,pushunit.tiley,1)[1] == stopunit)then stophere = true end
   end
   if stophere then break end
  table.insert(allmoved,{pushunit.id,pushdir})
 moveunits()
 local ispush2 = objectswithproperty("push")
 for pushi2, pushunit2 in ipairs(ispush2) do
   local here = on(pushunit2)
   if(#here > 0)then
     for i,there in ipairs(here) do
     if(there.moving)then
    --table.insert(allmoved,{pushunit,here[1].dir})
    --moveunit(allmoved,{pushunit,here[1].dir})
   -- moveunits()
   if(pushunit2.id ~= pushunit.id)then
    table.insert(pushed,{pushunit2.id,there.dir})
   end
   break
  end
 end
  end
 end
end
moveunits()
local istele = objectswithproperty("tele")
 for i,tele in ipairs(istele)do
  local ontele = on(tele)
  for j,teled in ipairs(ontele)do
     for k,obj in ipairs(istele)do
      if (obj.name == tele.name) and (obj ~= tele) then
        update(teled.id,obj.x,obj.y)
      end
    end
  end
 end
 --[[for i,moved in ipairs(allmoved) do
   local dir = moved[2]
   local unit = moved[1]
   if(dir == "right")then unit.x = unit.x+tilesize
 elseif(dir == "left")then unit.x = unit.x-tilesize
elseif(dir == "down")then unit.y = unit.y+tilesize
elseif(dir == "up")then unit.y = unit.y-tilesize end
unit.dir = dir
 end
 allmoved = {}
 --]]
end
function moveunits()
  for i,moved in ipairs(allmoved) do
    local dir = moved[2]
    local unitid = moved[1]
    local unit = Objects[unitid]
    local nx,ny = unit.x,unit.y
        if(dir == "right")then nx = nx+tilesize
  elseif(dir == "left")then nx = nx-tilesize
 elseif(dir == "down")then ny = ny+tilesize
 elseif(dir == "up")then ny = ny-tilesize end
 local here = allhere(nx,ny)
 local free = true
 for h,there in ipairs(here) do
  for s,stop in ipairs(objectswithproperty("stop"))do
    if(stop==there)then
     free = false
    end
  end
  --end
 end
    if(free)then
    if(dir == "right")then unit.x = unit.x+tilesize
  elseif(dir == "left")then unit.x = unit.x-tilesize
 elseif(dir == "down")then unit.y = unit.y+tilesize
 elseif(dir == "up")then unit.y = unit.y-tilesize end
 unit.dir = dir
 unit.moving = true
end
  end
  allmoved = {}
end
function update(unitid,x,y)
 local unit = Objects[unitid]
 unit.x = x
 unit.y = y
 unit.moving = true
end
function trypush(unitid,x,y,dir,pulling)
 local unit = Objects[unitid]
 local newx = x + dir_to_xy(dir)[1]-- * tilesize
 local newy = y + dir_to_xy(dir)[2]-- * tilesize
 local pushed = allhere(newx,newy)
 if(ruleexists(pushed.name,"is","stop"))then
   return 0
 elseif(ruleexists(pushed.name,"is","push"))then
   return trypush(pushed.id,pushed.tilex,pushed.tiley,pushed.dir,pulling)
 elseif(ruleexists(pushed.name,"is","pull") and pulling)then
   return -1
 end
 return 1
end
function dopush(unitid,dir,pulling)
 local unit = Objects[unitid]
 local try = trypush(unit,unit.tilex,unit.tiley,dir,false)
 if(try == 1)then
   table.insert(allmoved,{unit,dir})
   local newx = unit.tilex + dir_to_xy(dir)[1]
   local newy = unit.tiley + dir_to_xy(dir)[2]
   local pushed = allhere(newx,newy)
   if(trypush(unit,newx,newy,dir) == 1)then
     for i,push in ipairs(pushed) do
       dopush(push.id,dir,false)
       push.color = {1,0,1}
     end
   end
 end
end
function dir_to_xy(dir)
  if(dir == "right")then return {1,0}
elseif(dir == "left")then return {-1,0}
elseif(dir == "down")then return {0,1}
elseif(dir == "up")then return {1,0}
else return {0,0} end
end
function allhere(x,y)
    local finalobjs3 = {}
      for a,b in ipairs(Objects) do
    if(x == b.x) and (y == b.y) then
     table.insert(finalobjs3,b)
    end
  end
  return finalobjs3
end
function blocked(x,y,dir)
 local obs1 = gettiles(dir,x,y,1)
 if(obs1 ~= nil)then
   if(#obs1 > 0)then
    local obs = obs1[1]
 if(ruleexists(obs.name,"is","stop"))then
  return true
 end
 if(ruleexists(obs.name,"is","push"))then

 end
end
end
 return false
end

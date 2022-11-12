love.filesystem.load("rules.lua")()
love.filesystem.load("main.lua")()
  allmoved = {}
  updates = {}


  function notmoved(unitid,dir)
    for i, j in ipairs(allmoved) do
      if j[1] == unitid and j[2] == dir then
        return false
      end
    end
    return true
  end


  local down = love.keyboard.isDown
function testmove()
  updates = {}
  for i,unit in ipairs(Objects) do
    unit.moving = false
  end
  local movers = objectswithproperty("move")
  for i,mover in ipairs(movers) do
   table.insert(allmoved,{mover.id,mover.dir})
  end
  local yous = objectswithproperty("you")
 for youi,younit in ipairs(yous) do

  if(down("w") or down("up"))then table.insert(allmoved,{younit.id,"up"})
elseif(down("a")or down("left"))then table.insert(allmoved,{younit.id,"left"})
elseif(down("s")or down("down"))then table.insert(allmoved,{younit.id,"down"})
elseif(down("d")or down("right"))then table.insert(allmoved,{younit.id,"right"}) end
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
 local isfear = objectswithverb("fear")
 for i,fear in ipairs(isfear) do
   local unit = fear.unit
   for a, b in ipairs({"up","right","left","down"}) do
     local ptl_fears = gettiles(b, unit.tilex, unit.tiley, 1)
     for _, ob in ipairs(ptl_fears) do
       if matches(fear.target, ob) then
         table.insert(allmoved,{unit.id,revdir(b)})
       end
     end
   end
 end
 moveunits()

end


function moveunits()
   pushedunits = {}
  for i,moved in ipairs(allmoved) do
    table.insert(updates, moved[1])
    local dir = moved[2]
    local unitid = moved[1]
    local unit = Objects[unitid]
    local nx,ny = unit.x,unit.y
        if(dir == "right")then nx = nx+tilesize
  elseif(dir == "left")then nx = nx-tilesize
 elseif(dir == "down")then ny = ny+tilesize
 elseif(dir == "up")then ny = ny-tilesize end

    if(iamstupid(unit,nx,ny,dir))then
      if(dir == "right")then
        unit.x = unit.x+tilesize
        unit.tilex = unit.tilex + 1
      elseif(dir == "left")then
        unit.x = unit.x-tilesize
        unit.tilex = unit.tilex - 1
      elseif(dir == "down")then
        unit.y = unit.y+tilesize
        unit.tiley = unit.tiley + 1
      elseif(dir == "up")then
        unit.y = unit.y-tilesize
        unit.tiley = unit.tiley - 1
      end
    unit.dir = dir
    unit.moving = true
     end
  end
  for pid, pdir  in pairs(pushedunits) do
    if notmoved(pid,pdir) then
      local punit = Objects[pid]
      punit.x = punit.x+ (dir_to_xy(pdir)[1]) * tilesize
      punit.y = punit.y+ (dir_to_xy(pdir)[2]) * tilesize
      punit.tilex = punit.tilex + (dir_to_xy(pdir)[1])
      punit.tiley = punit.tiley+ (dir_to_xy(pdir)[2])
      punit.dir = pdir
    end
  end
  pushedunits = {}
  allmoved = {}
end
function update(unitid,x,y)
 local unit = Objects[unitid]
 unit.x = x
 unit.y = y
 unit.moving = true
end

function moveunit(unitid,dir)
 local unit = Objects[unitid]
  unit.tilex = unit.tilex + (dir_to_xy(dir)[1])
  unit.tiley = unit.tiley + (dir_to_xy(dir)[2]) * tilesize
  unit.dir = dir
  unit.moving = true
  return true
end

function dir_to_xy(dir)
  if(dir == "right")then return {1,0}
elseif(dir == "left")then return {-1,0}
elseif(dir == "down")then return {0,1}
elseif(dir == "up")then return {0,-1}
else return {0,0} end
end

function smallcheck(ida,idb)
  if Objects[idb].small > Objects[ida].small then
    return true -- small always returns true if target object is smaller or equal
  end
  return false
end

function iamstupid(unit,x,y,dir,pushing)
  if x < tilesize or y < tilesize or x > tilesize * (levelx - 2) or y > tilesize * (levely - 1) then
    return false
  end
  for k,v in ipairs(allhere(x,y)) do
      if (ruleexists(v.id, v.name,"is","open") and ruleexists(unit.id, unit.name,"is","shut")) or (ruleexists(v.id, v.name,"is","shut") and ruleexists(unit.id, unit.name,"is","open")) and not smallcheck(unit.id,v.id) then

        handledels({v,unit})
        return true

      elseif (ruleexists(v.id, v.name,"is","push") or (ruleexists("text","is","push") and string.sub(v.name,1,5) == "text_")) and not smallcheck(unit.id,v.id) then

           if iamstupid(v,v.x+ (dir_to_xy(dir)[1]) * tilesize,v.y+ (dir_to_xy(dir)[2]) * tilesize, dir,true) then
             if pushing then
               pushedunits[unit.id] = dir
               --[[
               unit.x = unit.x+ (dir_to_xy(dir)[1]) * tilesize
               unit.y = unit.y+ (dir_to_xy(dir)[2]) * tilesize
               unit.tilex = unit.tilex + (dir_to_xy(dir)[1])
               unit.tiley = unit.tiley+ (dir_to_xy(dir)[2])
               unit.dir = dir
             end]]
             end

           else
             return false
           end
        elseif ruleexists(v.id, v.name,"is","stop") or (ruleexists("text","is","stop") and string.sub(v.name,1,5) == "text_") or ((ruleexists(v.id, v.name,"is","push") or (ruleexists("text","is","stop") and string.sub(v.name,1,5) == "text_"))and smallcheck(unit.id,v.id)) then
             return false
       end
   end
   if pushing  then
     pushedunits[unit.id] = dir
     --[[
     unit.x = unit.x+ (dir_to_xy(dir)[1]) * tilesize
     unit.y = unit.y+ (dir_to_xy(dir)[2]) * tilesize
     unit.tilex = unit.tilex + (dir_to_xy(dir)[1])
     unit.tiley = unit.tiley+ (dir_to_xy(dir)[2])
     unit.dir = dir]]
   end
   return true
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

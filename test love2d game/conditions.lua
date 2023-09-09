condf = {}
condf["lonely"] = function(id)
    local obj = Objects[id]
    if #on(obj) == 0 then
      return true
    end
    return false
end

condf["often"] = function(id)
    if math.ceil(math.random(0,4)) ~= 1 then
      return true
    else
      return false
    end
end

condf["seldom"] = function(id)
    if math.ceil(math.random(0,6)) == 1 then
      return true
    else
      return false
    end
end

condf["powered"] = function(id, _, p)
    if p then
      return false
    end
    return #objectswithproperty("power", true) > 0
end

condf["active"] = function(id, _, p)
    return active
end

condf["no"] = function(id, _, p)
    return false
end

condf["never"] = function(id, _, p)
    return false
end


condf["on"] = function(id, args, p)
    local obj = Objects[id]
    local done = 0

    local onthis = on(obj)
    for i, j in ipairs(args) do
      for n, m in ipairs(onthis) do
        if m.id ~= id then
          if matches(j, m) then
            done = done + 1
            break
          end
        end
      end
    end
    return done == #args
end

condf["above"] = function(id, args, p)
  local obj = Objects[id]
  local done = 0

  local belowthis = {}

  for i, j in ipairs(Objects) do
    if id ~= j.id and j.tilex == obj.tilex and j.tiley > obj.tiley then
      table.insert(belowthis, j)
    end
  end

  for i, j in ipairs(args) do
    for n, m in ipairs(belowthis) do
      if m.id ~= id then
        if matches(j, m) then
          done = done + 1
          break
        end
      end
    end
  end
  return done == #args
end

condf["below"] = function(id, args, p)
  local obj = Objects[id]
  local done = 0

  local belowthis = {}

  for i, j in ipairs(Objects) do
    if id ~= j.id and j.tilex == obj.tilex and j.tiley < obj.tiley then
      table.insert(belowthis, j)
    end
  end

  for i, j in ipairs(args) do
    for n, m in ipairs(belowthis) do
      if m.id ~= id then
        if matches(j, m) then
          done = done + 1
          break
        end
      end
    end
  end
  return done == #args
end

condf["near"] = function(id, args, p)
  local obj = Objects[id]

  local done = 0

  local results = {}

  for i, j in ipairs(Objects) do
    if id ~= j.id then

      local xdiff = math.abs(j.tilex - obj.tilex)
      local ydiff = math.abs(j.tiley - obj.tiley)
      if xdiff <= 1 and ydiff <= 1 then
        table.insert(results, j)
      end
    end
  end

  for i, j in ipairs(args) do
    for n, m in ipairs(results) do
      if m.id ~= id then
        if matches(j, m) then
          done = done + 1
          break
        end
      end
    end
  end
  return done == #args
end

condf["nextto"] = function(id, args, p)
  local obj = Objects[id]

  local done = 0

  local results = {}

  for i, j in ipairs(Objects) do
    if id ~= j.id then

      local xdiff = math.abs(j.tilex - obj.tilex)
      local ydiff = math.abs(j.tiley - obj.tiley)
      if (xdiff + ydiff == 1) then
        table.insert(results, j)
      end
    end
  end

  for i, j in ipairs(args) do
    for n, m in ipairs(results) do
      if m.id ~= id then
        if matches(j, m) then
          done = done + 1
          break
        end
      end
    end
  end
  return done == #args
end


function testcond(conds_, unitid, preventpowerloop)
  local conds = conds_ or {}

  local condtype = ""
  local result = true
  for i, j in ipairs(conds) do
    condtype = j[1]
    if condf[condtype] ~= nil then
      result = result and condf[condtype](unitid, j[2], preventpowerloop)
    end
  end
  return result
end

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

condf["on"] = function(id, args, p)
    local obj = Objects[id]
    local done = 0
    for i, j in ipairs(Objects) do
      if j.id ~= id then
        if ison(j, obj) then
          for n, m in ipairs(args) do
            if matches(m, j) then
              done = done + 1
            end
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
    result = result and condf[condtype](unitid, j[2], preventpowerloop)
  end
  return result
end

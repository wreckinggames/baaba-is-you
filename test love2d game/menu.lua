function notimplemented()

end

menu_state = "main"

mutemusic = false

function menu()

    -- drawing the menu itself we have the 4 buttons play (0% done) settings (dont even have an idea) quit (who the heck uses this) and editor (was already in the game)
    local width, height = love.graphics.getDimensions()
    for i, j in ipairs(menu_buttons) do

        if j.state == menu_state then

          local jx, jy = j.x * (width / 1280), j.y * (height / 820)
          local jsizex, jsizey = j.sizex * (width / 1280), j.sizey * (height / 820)
          love.graphics.setColor(j.color[1], j.color[2], j.color[3])

          if editlevelname and j.text == "Rename" then
            love.graphics.setColor((j.color[1]) / 2, (j.color[2]) / 2, (j.color[3]) / 2)
          end

          if mutemusic and j.text == "Mute Music" then
            love.graphics.setColor(0.95, 0.3, 0.85)
          end

          if j.justtext ~= true then
            if love.mouse.getX() > jx and love.mouse.getX() < jx + jsizex and  love.mouse.getY() > jy and love.mouse.getY() < jy + jsizey then
              if not love.mouse.isDown() then
                love.graphics.setColor((j.color[1] + 1) / 2, (j.color[2] + 1) / 2, (j.color[3] + 1) / 2)
              else
                love.graphics.setColor((j.color[1]) / 2, (j.color[2]) / 2, (j.color[3]) / 2)
              end
            end
          end




          love.graphics.rectangle("fill", jx, jy, jsizex, jsizey)
          love.graphics.rectangle("line", jx, jy, jsizex, jsizey)
          love.graphics.setColor(j.color[4], j.color[5], j.color[6])
          if j.id ~= "textinput" then
            love.graphics.printf(j.text, jx, jy + jsizey / 4, jsizex, "center")
          else
            love.graphics.printf(current_textinput, jx, jy + jsizey / 4, jsizex, "center", 0)
          end

        end
    end
end

function menu_load()

  menu_buttons = {}


  menu_state = "main"


  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Editor",
    x = 600,
    y = 400,
    sizex = 60,
    sizey = 30,
    func = gotoeditor,
    state = "main"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Quit",
    x = 600,
    y = 500,
    sizex = 60,
    sizey = 30,
    func = love.event.quit,
    state = "main"
  })


  table.insert(menu_buttons, {
    color = {0.2, 0.2, 0.2, 0, 0, 0},
    text = "Play",
    x = 600,
    y = 350,
    sizex = 60,
    sizey = 30,
    func = gotoplay,
    state = "main"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Settings",
    x = 600,
    y = 450,
    sizex = 60,
    sizey = 30,
    func = gotosettings,
    state = "main"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Back",
    x = 600,
    y = 650,
    sizex = 60,
    sizey = 30,
    func = backtomenu,
    state = "settings"
  })


  table.insert(menu_buttons, {
    color = {0.3, 0.3, 0.4, 0, 0, 0},
    text = "Mute Music",
    x = 600,
    y = 230,
    sizex = 60,
    sizey = 50,
    state = "settings",
    func = nomoremusic
  })

  table.insert(menu_buttons, {
    color = {0.3, 0.3, 0.4, 0, 0, 0},
    text = "Useless Setting",
    x = 580,
    y = 300,
    sizex = 100,
    sizey = 40,
    state = "settings",
    func = notimplemented
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Back",
    x = 1200,
    y = 5,
    sizex = 60,
    sizey = 30,
    func = gotomenu,
    state = "editor"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Back",
    x = 1200,
    y = 5,
    sizex = 60,
    sizey = 30,
    func = gotomenuplay,
    state = "play"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Back",
    x = 1200,
    y = 5,
    sizex = 60,
    sizey = 30,
    func = gotomenuplay,
    state = "playing"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Save",
    x = 290,
    y = 725,
    sizex = 60,
    sizey = 30,
    func = dolevelsave,
    state = "editor"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Load",
    x = 360,
    y = 725,
    sizex = 60,
    sizey = 30,
    func = dolevelload,
    state = "editor"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.3, 0.7, 0, 0, 0},
    text = "Rename",
    x = 80,
    y = 725,
    sizex = 60,
    sizey = 30,
    func = dolevelname,
    state = "editor"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.2, 0.3, 1, 1, 1},
    text = "",
    x = 150,
    y = 720,
    sizex = 125,
    sizey = 40,
    state = "editor",
    justtext = true,
    id = "textinput"
  })



end


function addpopup(x, y, things, _sx, _sy)

  table.insert(menu_buttons, {
    color = {0.2, 0.2, 0.3, 1, 1, 1},
    text = "",
    x = x,
    y = y,
    sizex = _sx or 200,
    sizey = _sy or 200,
    state = gamestate,
    id = "popup",
    justtext = true,
    popup = true
  })

  for _, stuff in ipairs(things) do
    table.insert(menu_buttons, {
      color = stuff.color or {0.2, 0.2, 0.3, 1, 1, 1},
      text = stuff.text or "",
      x = x + (stuff.dx or 0),
      y = y + (stuff.dy or 0),
      sizex = stuff.sizex or 200,
      sizey = stuff.sizey or 200,
      state = gamestate,
      id = "popup",
      func = stuff.func,
      popup = true
    })
  end


end





function gotoeditor()
  x_offset = 0
  y_offset = 0

  playmusic("default")
  gamestate = "editor"
  menu_state = "editor"

  palette_id = 1
  loadPalette(all_palettes[palette_id])

  initui()
end

function gotogame()
  gamestate = "playing"
  menu_state = "playing"
end

function gotomenu()
  leveltree = {}
  playmusic("baaba")
  gamestate = "menu"
  menu_state = "main"
  heldtile = ""
  editor_curr_objects = {}
end

function gotomenuplay()
  leveltree = {}
  delete_these_specific_menu_buttons()



  levelname = ""


  dielevel()
  love.timer.sleep(0.1)


  playmusic("baaba")
  gamestate = "menu"
  menu_state = "main"
  editor_curr_objects = {}


end

function gotoplay()
  menu_state = "play"

  local filest = {}
  local file_table = love.filesystem.getDirectoryItems("levels")
  for i,v in ipairs(file_table) do
    local file = "levels/"..v
    local info = love.filesystem.getInfo(file)
    if info then
      if info.type == "file" then
        table.insert(menu_buttons, {
          color = {0.2, 0.3, 0.7, 0, 0, 0},
          text = v,
          x = 350 + 400 * ((i - 1) % 2),
          y = 70 + 35 * math.floor((i - 1) / 2),
          sizex = 160,
          sizey = 30,
          func = "auto_playlevel",
          state = "play"
        })
      end
    end
  end
end

function backtomenu()
  gamestate = "menu"
  menu_state = "main"
end

function nomoremusic()
  mutemusic = not mutemusic
  if mutemusic then
    music:setVolume(0)
  else
    music:setVolume(0.3)
  end
end

function gotosettings()
  menu_state = "settings"
end

function dolevelsave()
  saveleveldata(levelname)
end
function dolevelload()
  loadleveldata(levelname)
end

function dolevelname()
  editlevelname = not editlevelname
  if not editlevelname then
    levelname = current_textinput
  end
end
windowsize = 1
windowtilesize = 1
function windowsmaller()
  if windowsize == 1 then
    windowsize = 0.75
    windowtilesize = 0.75
    for i, j in ipairs(menu_buttons) do
      j.x = j.x * 0.75
      j.y = j.y * 0.75
      j.sizex = j.sizex * 0.75
      j.sizey = j.sizey * 0.75
    end
    tilesize = 36
  end
end
function windowbigger()
  if windowsize < 1 then
    windowsize = 1
    windowtilesize = 1
    for i, j in ipairs(menu_buttons) do
      j.x = j.x * (4 / 3.0)
      j.y = j.y * (4 / 3.0)
      j.sizex = j.sizex * (4 / 3.0)
      j.sizey = j.sizey * (4 / 3.0)
    end
    tilesize = 48
  end
end

-- NOTE: What am i even doing anymore
function delete_these_specific_menu_buttons()

  local removes = {}
  for a, b in ipairs(menu_buttons) do
    if b.func == "auto_playlevel" then
      table.insert(removes, a)
    end
  end
  local h = 0
  for a, b in ipairs(removes) do
    table.remove(menu_buttons, b - h)
    h = h + 1
  end

end

function loadlevel_advanced(j)
  dolevelload()
  loadlevel()
end

function playlevel_advanced(j)

  gotogame()
  love.timer.sleep(1)
  levelname = j.text
  full_level_load()
  gotogame()
  playmusic(musiclist[levelmusic])
  delete_these_specific_menu_buttons()

end

function menu_press()

  local width, height = love.graphics.getDimensions()


  for i, j in ipairs(menu_buttons) do
      if j.justtext ~= true and j.state == menu_state then
        local jx, jy = j.x * (width / 1280), j.y * (height / 820)
        local jsizex, jsizey = j.sizex * (width / 1280), j.sizey * (height / 820)
        if love.mouse.getX() > jx and love.mouse.getX() < jx + jsizex and  love.mouse.getY() > jy and love.mouse.getY() < jy + jsizey then
          if j.func ~= "auto_playlevel" then
            j.func()
          else
            table.insert(leveltree, j.text)
            gotogame()
            love.timer.sleep(1)
            levelname = j.text
            dolevelload()
            love.timer.sleep(1)
            loadlevel()
            gotogame()
            playmusic(musiclist[levelmusic])
            delete_these_specific_menu_buttons()

            x_offset = (love.graphics.getWidth() - levelx * tilesize) / 2
            y_offset = (love.graphics.getHeight() - (levely + 1) * tilesize) / 2
            break

          end
        end
      end
  end

end

curmusic = ""
function playmusic(name)
  if curmusic == name then
    return
  end
  curmusic = name
  music:stop()
  music = love.audio.newSource("sound/" .. name .. ".wav","static")
  music:play()
  music:setLooping(true)
  if mutemusic then
    music:setVolume(0)
  else
    music:setVolume(1)
    if name ~= "default" then
      music:setVolume(0.3)
    end
  end
end

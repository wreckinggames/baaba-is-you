function notimplemented()

end

menu_state = "main"

function menu()

    -- drawing the menu itself we have the 4 buttons play (0% done) settings (dont even have an idea) quit (who the heck uses this) and editor (was already in the game)

    for i, j in ipairs(menu_buttons) do

        if j.state == menu_state then
          love.graphics.setColor(j.color[1], j.color[2], j.color[3])

          if editlevelname and j.text == "Rename" then
            love.graphics.setColor((j.color[1]) / 2, (j.color[2]) / 2, (j.color[3]) / 2)
          end

          if j.justtext ~= true then
            if love.mouse.getX() > j.x and love.mouse.getX() < j.x + j.sizex and  love.mouse.getY() > j.y and love.mouse.getY() < j.y + j.sizey then
              if not love.mouse.isDown() then
                love.graphics.setColor((j.color[1] + 1) / 2, (j.color[2] + 1) / 2, (j.color[3] + 1) / 2)
              else
                love.graphics.setColor((j.color[1]) / 2, (j.color[2]) / 2, (j.color[3]) / 2)
              end
            end
          end




          love.graphics.rectangle("fill", j.x, j.y, j.sizex, j.sizey)
          love.graphics.rectangle("line", j.x, j.y, j.sizex, j.sizey)
          love.graphics.setColor(j.color[4], j.color[5], j.color[6])
          if j.id ~= "textinput" then
            love.graphics.printf(j.text, j.x, j.y + j.sizey / 4, j.sizex, "center")
          else
            love.graphics.printf(current_textinput, j.x, j.y + j.sizey / 4, j.sizex, "center")
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
    func = notimplemented,
    state = "main"
  })

  table.insert(menu_buttons, {
    color = {0.2, 0.2, 0.2, 0, 0, 0},
    text = "Settings",
    x = 600,
    y = 450,
    sizex = 60,
    sizey = 30,
    func = notimplemented,
    state = "main"
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


function gotoeditor()
  gamestate = "editor"
  menu_state = "editor"

  initui()
end

function gotomenu()
  gamestate = "menu"
  menu_state = "main"
  heldtile = ""
  editor_curr_objects = {}
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

function menu_press()

  for i, j in ipairs(menu_buttons) do
      if j.justtext ~= true and j.state == menu_state then
        if love.mouse.getX() > j.x and love.mouse.getX() < j.x + j.sizex and  love.mouse.getY() > j.y and love.mouse.getY() < j.y + j.sizey then
          j.func()
        end
      end
  end

end

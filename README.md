# Rook
Simple messagebox library for Love2d
# Demo
```lua
local Font = require("font/Font")
local Rook = require("rook")

function love.load()
  w, h = love.graphics.getWidth(), love.graphics.getHeight()
  love.window.setMode(w, h, {highdpi = false})
  w, h = love.graphics.getWidth(), love.graphics.getHeight()
  msgbox1 = Rook:new(w / 2 - 700 / 2, 210, 700, 160, {0, 0, 0}, "Among Us", love.graphics.newImage("AmongUs.jpg"), Font.MC,
  {
    "I'm Among Us, nice to meet you :D",
    "I want you to answer my question: Do you like the game Among Us?"
  },
  {
    "Yes I really like that game",
    "No that game is really bad"
  },
  {
    function()
      msgbox2 = Rook:new(w / 2 - 700 / 2, 210, 700, 160, {0, 0, 0}, "Among Us", love.graphics.newImage("AmongUs.jpg"), Font.MC,
      {
        "It's good that you like it :3"
      },
      {})
    end,
    function()
      msgbox2 = Rook:new(w / 2 - 700 / 2, 210, 700, 160, {0, 0, 0}, "Among Us", love.graphics.newImage("AmongUs.jpg"), Font.MC,
      {
        "Wrong answer, you're a bad boy >=("
      },
      {
        "Retry"
      },
      {
        function()
          msgbox2 = nil
          msgbox1.msgQueue = 2
          msgbox1.timer.sec = 0.02
          msgbox1.msgIndex = 1
        end
      })
    end
  })
end

function love.update(dt)
  msgbox1:update(dt)
  if msgbox2 then
    msgbox2:update(dt)
  end
end

function love.draw()
  setColor({169, 169, 169})
  love.graphics.rectangle("fill", 0, 0, w, h)
  msgbox1:draw()
  if msgbox2 then
    msgbox2:draw()
  end
end

function love.touchpressed(id, x, y)
  msgbox1:touchPressed(id, x, y)
  if msgbox2 then
    msgbox2:touchPressed(id, x, y)
  end
end
```
# Preview
[![SWNFr.jpg](https://s12.gifyu.com/images/SWNFr.jpg)](https://gifyu.com/image/SWNFr)

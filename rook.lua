function setColor(color)
  love.graphics.setColor(love.math.colorFromBytes(unpack(color)))
end

local Timer = {}

function Timer:new(sec, listener)
  local t = {}
  setmetatable(t, {__index = self})
  t.sec = sec
  t.listener = listener
  return t
end

function Timer:update(dt)
  self.sec = self.sec - dt
  if self.sec <= 0 then
    self.listener()
  end
end

local Rook = {}

function Rook:new(x, y, w, h, color, name, avatar, font, msg, option, listener)
  local r = {}
  setmetatable(r, {__index = self})
  r.x = x
  r.y = y
  r.w = w
  r.h = h
  r.hC = h
  r.yC = y
  r.color = color
  r.name = name
  r.avatar = avatar
  r.font = font
  r.msg = msg
  r.option = option
  r.imgHeight = r.h - 10
  r.optionLen = #option
  r.listener = listener
  local w, seq = font:getWrap(msg[#msg], r.w - (10 + r.imgHeight) - 5)
  local y = 5 + font:getHeight() * #seq
  for i, v in ipairs(option) do
    w, seq = font:getWrap(">" .. v, r.w - (10 + r.imgHeight) - 5)
    r.option[i] = {txt = ">" .. v, y = y, line_ = #seq}
    y = y + font:getHeight() * #seq
    r.optionLen = r.optionLen + r.option[i].txt:len()
  end
  r.canvas = love.graphics.newCanvas(r.w, r.h)
  r.msgQueue = 1
  r.msgIndex = 1
  r.timer = Timer:new(0.02, function()
    if r.msgQueue ~= #r.msg then
      if r.msgIndex < r.msg[r.msgQueue]:len() then
        r.msgIndex = r.msgIndex + 1
      end
      return
    end
    if r.msgIndex < r.msg[r.msgQueue]:len() + r.optionLen then
      r.msgIndex = r.msgIndex + 1
    end
  end)
  return r
end

function Rook:update(dt)
  self.timer:update(dt)
  local txt = self.msg[self.msgQueue]
  if self.msgQueue == #self.msg then
    for _, v in ipairs(self.option) do
      txt = txt .. "\n" .. v.txt
    end
  end
  local w, seq = self.font:getWrap(txt, self.w - (10 + self.imgHeight) - 5)
  -- ka = #seq
  if self.font:getHeight() * #seq <= self.hC then
    self.h = self.hC
    self.y = self.yC
    self.imgHeight = self.h - 10
    self.canvas:release()
    self.canvas = love.graphics.newCanvas(self.w, self.h)
  else
    local add = ((self.font:getHeight() * #seq - self.hC))
    self.h = self.hC + add + 5
    self.y = self.yC - add - 5
    self.imgHeight = self.h - 10
    self.canvas:release()
    self.canvas = love.graphics.newCanvas(self.w, self.h)
  end
end

function Rook:draw()
  self.canvas:renderTo(function()
    love.graphics.clear()
    setColor(self.color)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    setColor({255, 255, 255})
    love.graphics.draw(self.avatar, 5, 5, 0, self.imgHeight / self.avatar:getWidth(), self.imgHeight / self.avatar:getHeight())
    local txtW = 10 + self.imgHeight
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    local text = self.msg[self.msgQueue]
    if self.msgQueue == #self.msg then
      for _, v in ipairs(self.option) do
        text = text .. "\n" .. v.txt
        -- love.graphics.rectangle("line", txtW, v.y, self.w - (10 + self.imgHeight) - 5, self.font:getHeight() * v.line_)
      end
    end
    love.graphics.printf(text:sub(1, self.msgIndex), txtW, 5, self.w - txtW - 5)
    -- love.graphics.print((self.font:getHeight() * ka) .. " " .. self.h, 100, 100)
    love.graphics.setFont(font)
  end)
  love.graphics.draw(self.canvas, self.x, self.y)
  setColor({255, 255, 255})
  local name = love.graphics.newText(self.font, self.name)
  love.graphics.draw(name, self.x, self.y - self.font:getHeight())
  name:release()
end

function Rook:touchPressed(id, x, y)
  if self.msgQueue ~= #self.msg then
    self.msgQueue = self.msgQueue + 1
    self.msgIndex = 1
    return
  end
  if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
    local x, y = x - self.x, y - self.y
    if x < 10 + self.imgHeight or x > (10 + self.imgHeight) + (self.w - (10 + self.imgHeight) - 5) then
      return
    end
    for i, v in ipairs(self.option) do
      if y >= v.y and y <= v.y + (self.font:getHeight() * v.line_) then
        self.listener[i]()
        return
      end
    end
  end
end

return Rook
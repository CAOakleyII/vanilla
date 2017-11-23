AutoAttack = {}

function AutoAttack:new()
  local obj = {
    isActive = false,
    cool_down = 1,
    width = 19,
    height = 5,
    speed = 250,
    objects = {}
  }
  self.__index = self;
  return setmetatable(obj, self)
end

function AutoAttack:attack(x,y, targetx, targety)

  local angle = math.atan2(targety - y, targetx - x);
  local a = { name = "ranger_auto_attack", x = x , y = y, angle = angle }
  world:add(a, x, y, self.width, self.height)
  a.animation = self:load()
  table.insert(self.objects, a)
  return
end

function AutoAttack:load()
  return love.graphics.newImage('assets/spear.png')
end

function AutoAttack:update(dt)
  for k,v in pairs(self.objects) do
    v.x = v.x + (self.speed * dt) * math.cos(v.angle)
    v.y = v.y + (self.speed * dt) * math.sin(v.angle)
  end
end

function AutoAttack:draw()
  for k,v in pairs(self.objects) do
    love.graphics.draw(v.animation, v.x, v.y, v.angle, 1,1, v.animation:getWidth()/2, v.animation:getHeight()/2)
  end
end

return AutoAttack;

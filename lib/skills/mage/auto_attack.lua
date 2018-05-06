AutoAttack = {}

function AutoAttack:new()
  local obj = {
    isActive = false,
    cool_down = 1,
    current_cool_down = 0,
    width = 19,
    height = 5,
    speed = 250,
    objects = {}
  }
  self.__index = self;
  return setmetatable(obj, self)
end

function AutoAttack:attack(x,y, targetx, targety)
  self.current_cool_down = self.cool_down
  
  local angle = math.atan2(targety - y, targetx - x);
  local a = { name = "mage_auto_attack", x = x , y = y, angle = angle }
  world:add(a, x, y, self.width, self.height)
  a.animation = self:load()
  table.insert(self.objects, a)
  return
end

function AutoAttack:load()
  return love.graphics.newImage('assets/spear.png')
end


function AutoAttack:update(dt)
  if (self.current_cool_down > 0) then
    self.current_cool_down = self.current_cool_down - dt
  end

  for k,v in pairs(self.objects) do

    local cols, len
    v.x, v.y, cols, len = self:move(v, v.x + (self.speed * dt) * math.cos(v.angle), v.y + (self.speed * dt) * math.sin(v.angle))

    if len > 0 then
      --world:remove(v)
      --self.objects[k] = nil
    end


  end
end

function AutoAttack:move(object, goalX, goalY)
  local actualX, actualY, cols, len = world:move(object, goalX + offsetX, goalY + offsetY)
  return actualX - offsetX, actualY - offsetY, cols, len
end

function AutoAttack:draw()
  for k,v in pairs(self.objects) do
    love.graphics.print(v.x .. ", " ..v.y, v.x, v.y)
    love.graphics.draw(v.animation, v.x, v.y, v.angle, 1,1, v.animation:getWidth()/2, v.animation:getHeight()/2)
  end
end

return AutoAttack;

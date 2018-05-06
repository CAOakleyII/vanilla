local CharacterTypes = require 'lib.character_types'

Zombie = {}

-- Constructor
--
--
function Zombie:new(pos)
  local obj = {
      type = CharacterTypes.Zombie,
      orientation = Orientations.Left,
      animations = {},
      body = nil,
      speed = 3,
      current_health = 50,
      max_health = 50,
      pos = {
        x = pos.x,
        y = pos.y
      }
  }
  self.__index = self
  return setmetatable(obj, self)
end


function Zombie:run(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations['attack']:pause()
  self.animations['idle']:pause()
  self.animations['run']:play()
end

function Zombie:idle(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations['run']:pause()
  self.animations['idle']:play()
end

function Zombie:attack(orientation)
  if orientation then
    self.orientation = orientation
  end
    self.animations['idle']:pause()
    self.animations['run']:pause()
    self.animations['attack']:play()
end

function Zombie:load()

    -- idle
    local idle = Animation:new('idle', 'assets/Zombie_Idle.png')
    idle:load(32,32)

    -- run
    local run = Animation:new('run','assets/Zombie_Walk.png')
    run:load(32,32)

    -- attack
    local attack = Animation:new('attack', 'assets/Zombie_Attack.png')
    attack:load(32,32)

    self.animations['idle'] = idle
    self.animations['run'] = run
    self.animations['attack'] = attack

    idle:play()
end

function Zombie:draw()
  love.graphics.setColor(255,0,0);
  love.graphics.rectangle("line", self.pos.x - 5, self.pos.y - 10, 40, 5)
  love.graphics.rectangle("fill", self.pos.x - 5, self.pos.y - 10, self.current_health / self.max_health * 40, 5)
  love.graphics.setColor(255,255,255);
  love.graphics.print(self.pos.x .. ", " .. self.pos.y, self.pos.x, self.pos.y + 50)

  for k,v in pairs(self.animations) do
    v:draw(self.pos.x, self.pos.y, self.orientation)
  end
end

function Zombie:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end
end
return Zombie

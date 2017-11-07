local CharacterTypes = require 'lib.character_types'

Zombie = {}

-- Constructor
--
--
function Zombie:new()
  local obj = {
      type = CharacterTypes.Zombie,
      orientation = Orientations.Left,
      animations = {},
      speed = 3,
      pos = {
        x = 200,
        y = 200
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
    local run = Animation:new('run','assets/Zombie_Run.png')
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

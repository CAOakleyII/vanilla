local CharacterTypes = require 'lib.character_types'

Mage = {}

-- Constructor
--
--
function Mage:new()
  local obj = {
      type = CharacterTypes.Mage,
      orientation = Orientations.Right,
      animations = {},
      speed = 5,
      pos = {
        x = 200,
        y = 200
      }
  }
  self.__index = self
  return setmetatable(obj, self)
end


function Mage:run(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations['idle']:pause()
  self.animations['run']:play()
end

function Mage:idle(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations['run']:pause()
  self.animations['idle']:play()
end

function Mage:load()
    -- idle
    local idle = Animation:new('idle', 'assets/Mage_Idle.png')
    idle:load(32,32)

    -- run
    local run = Animation:new('run','assets/Mage_Run.png')
    run:load(32,32)

    -- attack
    local attack = Animation:new('attack', 'assets/Mage_AttackNoWeapon.png')
    attack:load(64,64)

    self.animations['idle'] = idle
    self.animations['run'] = run
    self.animations['attack'] = attack

    idle:play()
end

function Mage:draw()
  for k,v in pairs(self.animations) do
    v:draw(self.pos.x, self.pos.y, self.orientation)
  end
end

function Mage:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end
end
return Mage

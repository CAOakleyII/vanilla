local CharacterTypes = require 'lib.character_types'

Ranger = { }

-- Constructor
--
--
function Ranger:new()
  local obj = {
      type = CharacterTypes.Ranger,
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


function Ranger:run(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations['idle']:pause()
  self.animations['run']:play()
end

function Ranger:idle(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations['run']:pause()
  self.animations['idle']:play()
end

function Ranger:load()
    -- idle
    local idle = Animation:new('idle', 'assets/Ranger_Idle.png')
    idle:load(32,32)

    -- run
    local run = Animation:new('run','assets/Ranger_Run.png')
    run:load(32,32)

    -- attack
    local attack = Animation:new('attack', 'assets/Ranger_AttackNoWeapon.png')
    attack:load(64,64)

    self.animations['idle'] = idle
    self.animations['run'] = run
    self.animations['attack'] = attack

    idle:play()
end

function Ranger:draw()
  for k,v in pairs(self.animations) do
    v:draw(self.pos.x, self.pos.y, self.orientation)
  end
end

function Ranger:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end
end

return Ranger

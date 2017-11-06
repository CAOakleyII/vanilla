local CharacterTypes = require 'lib.character_types'
local Animation = require 'lib.animation'
local Orientations = require 'lib.orientations'

Warrior = {
}

-- Constructor
--
--
function Warrior:new()
  local obj = {
      type = CharacterTypes.Warrior,
      orientation = Orientations.Right,
      animations = {},
      pos = {
        x = 200,
        y = 200
      }
  }
  self.__index = self
  return setmetatable(obj, self)
end

function Warrior:run()
    self.animations['idle']:pause()
    self.animations['run']:play()
end

function Warrior:idle()
    self.animations['run']:pause()
    self.animations['idle']:play()
end

function Warrior:attack()
    self.animations['idle']:pause()
    self.animations['run']:pause()
    self.animations['attack']:play()
end
function Warrior:load()
    -- idle
    local idle = Animation:new('idle', 'assets/Warrior_Idle.png')
    idle:load(32,32)

    -- run
    local run = Animation:new('run','assets/Warrior_Run.png')
    run:load(32,32)

    -- attack
    local attack = Animation:new('attack', 'assets/Warrior_AttackNoWeapon.png')
    attack:load(64,64)

    self.animations['idle'] = idle
    self.animations['run'] = run
    self.animations['attack'] = attack

    idle:play()
end

function Warrior:draw()
  for k,v in pairs(self.animations) do
    v:draw(self.pos.x, self.pos.y, self.orientation)
  end
end

function Warrior:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end
end

return Warrior

local CharacterTypes = require 'lib.character_types'
local Animation = require 'lib.animation'
local AutoAttack = require 'lib.skills.mage.auto_attack'

Mage = {}

-- Constructor
--
--
function Mage:new(pos, id)
  pos = pos or { x = 200, y = 200 }
  local obj = {
      type = CharacterTypes.Mage,
      orientation = Orientations.Right,
      body = { width = 32, height = 32 },
      animations = {},
      skills = {
        auto_attack = AutoAttack:new()
      },
      speed = 96,
      current_health = 100,
      max_health = 100,
      pos = pos
  }
  self.__index = self
  return setmetatable(obj, self)
end


function Mage:run(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations.attack:pause()
  self.animations.idle:pause()
  self.animations.run:play()
end

function Mage:idle(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations.attack:pause()
  self.animations.run:pause()
  self.animations.idle:play()
end

function Mage:attack(orientation)
  if orientation then
    self.orientation = orientation
  end
    self.animations.idle:pause()
    self.animations.run:pause()
    self.animations.attack:play()
end

function Mage:auto_attack(targetx, targety, orientation)
  if orientation then
    self.orientation = orientation
  end
  self:attack(orientation)
  self.skills.auto_attack:attack(self.pos.x, self.pos.y, targetx, targety)
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
    attack:load(32,32)

    self.animations.idle = idle
    self.animations.run = run
    self.animations.attack = attack

    idle:play()
end

function Mage:draw()
  love.graphics.setColor(255,0,0);
  love.graphics.rectangle("line", self.pos.x - 5, self.pos.y - 10, 40, 5)
  love.graphics.rectangle("fill", self.pos.x - 5, self.pos.y - 10, self.current_health / self.max_health * 40, 5)
  love.graphics.setColor(255,255,255);

  for k,v in pairs(self.animations) do
    v:draw(self.pos.x, self.pos.y, self.orientation)
  end

  for k,v in pairs(self.skills) do
    v:draw()
  end
end

function Mage:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end

  for k,v in pairs(self.skills) do
    v:update(dt)
  end
end
return Mage

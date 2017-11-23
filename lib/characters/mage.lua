local CharacterTypes = require 'lib.character_types'

Mage = {}

-- Constructor
--
--
function Mage:new()
  local obj = {
      type = CharacterTypes.Mage,
      orientation = Orientations.Right,
      body = { width = 32, height = 32 },
      animations = {},
      speed = 96,
      current_health = 100,
      max_health = 100,
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
end

function Mage:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end
end
return Mage

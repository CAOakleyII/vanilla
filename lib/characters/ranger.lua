local AutoAttack = require 'lib.skills.ranger.auto_attack'
local CharacterTypes = require 'lib.character_types'

Ranger = { }

-- Constructor
--
--
function Ranger:new()
  local obj = {
      type = CharacterTypes.Ranger,
      orientation = Orientations.Right,
      body = { width = 32, height = 32 },
      animations = {},
      skills = {
        auto_attack = AutoAttack:new()
      },
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


function Ranger:run(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations.attack:pause()
  self.animations.idle:pause()
  self.animations.run:play()
end

function Ranger:idle(orientation)
  if orientation then
    self.orientation = orientation
  end
  self.animations.attack:pause()
  self.animations.run:pause()
  self.animations.idle:play()
end

function Ranger:attack(orientation)
  if orientation then
    self.orientation = orientation
  end
    self.animations.idle:pause()
    self.animations.run:pause()
    self.animations.attack:play()
end

function Ranger:auto_attack(targetx, targety, orientation)
  if orientation then
    self.orientation = orientation
  end
  self:attack(orientation)
  self.skills.auto_attack:attack(self.pos.x, self.pos.y, targetx, targety)

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
    attack:load(32,32)

    self.animations.idle = idle
    self.animations.run = run
    self.animations.attack = attack

    idle:play()
end

function Ranger:draw()
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

function Ranger:update(dt)
  for k,v in pairs(self.animations) do
    v:update(dt)
  end

  for k,v in pairs(self.skills) do
    v:update(dt)
  end
end

return Ranger

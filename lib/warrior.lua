local CharacterTypes = require 'lib.character_types'
local Animation = require 'lib.animation'
local Orientations = require 'lib.orientations'

Warrior = {
  type = CharacterTypes.Warrior,
  orientation = Orientations.Right,
  animations = {},
  pos = {
    x = 200,
    y = 200
  }
};

-- Constructor
--
--
function Warrior:new(obj)
  obj = obj or {};
  setmetatable(obj, self);
  self.__index = self;
  return obj;
end

function Warrior:run()

  if client then
    self.animations['idle']:pause();
    self.animations['run']:play();
  end
end

function Warrior:idle()
  if client then
    self.animations['run']:pause();
    self.animations['idle']:play();
  end
end

function Warrior:attack()
  if client then
    self.animations['idle']:pause();
    self.animations['run']:pause();
    self.animations['attack']:play();
  end
end
function Warrior:load()
  if client then
    -- idle
    local idle = Animation:new({ name = 'idle', sprite_sheet_path = 'assets/Warrior_Idle.png' });
    idle:load(32,32)

    -- run
    local run = Animation:new({ name = 'run', sprite_sheet_path = 'assets/Warrior_Run.png' });
    run:load(32,32);

    -- attack
    local attack = Animation:new({ name = 'attack', sprite_sheet_path = 'assets/Warrior_AttackNoWeapon.png' });
    attack:load(64,64);

    self.animations['idle'] = idle;
    self.animations['run'] = run;
    self.animations['attack'] = attack;

    idle:play();
  end
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

return Warrior;

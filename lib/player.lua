local Orientations = require 'lib.orientations';
local CharacterTypes = require 'lib.character_types';
local NetworkMessageTypes = require 'lib.network_message_types';
local Warrior = require 'lib.warrior';
local Mage = require 'lib.mage';
local Ranger = require 'lib.ranger';

Player = {
  name = '',
  character = nil,
  keys_down = {}
};

-- Constructor
--
--
function Player:new(obj, character_type)
  obj = obj or {};

  if character_type == CharacterTypes.Warrior then
    self.character = Warrior:new()
  elseif character_type == CharacterTypes.Mage then
    self.character = Mage:new()
  elseif character_type == CharacterTypes.Ranger then
    self.character = Ranger:new()
  end

  setmetatable(obj, self);
  self.__index = self;
  return obj;
end

function Player:load(bind_keys)
  if bind_keys then
    function love.keypressed(key)
      self.keys_down[key] = true;
    end
    function love.keyreleased(key)
      self.keys_down[key] = nil;
    end
    function love.mousepressed(x, y, button)
      self.keys_down['m' .. button] = true;
    end
    function love.mousereleased(x, y, button)
      self.keys_down['m' .. button] = nil;
    end
  end
  self.character:load();
end

function Player:update(dt)
  if self.keys_down['w'] then
    self.character:run();
  elseif self.keys_down['a'] then
    self.character:run();
  elseif self.keys_down['s'] then
    self.character:run();
  elseif self.keys_down['d'] then
    self.character:run();
    self.character.pos.x = self.character.pos.x + 5;
  else
    self.character:idle();
  end

  if self.keys_down['m1'] then
    -- self.character:attack();
  end
  self.character:update(dt);

  self:updateServer();
end

function Player:draw()
  love.graphics.print(self.name, self.character.pos.x - 8, self.character.pos.y - 20);
  self.character:draw();
end


function Player:updateServer()
  if client then
    client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
  end
end
function Player:destroy()
  --implement
end

return Player;

local Orientations = require 'lib.orientations'
local CharacterTypes = require 'lib.character_types'
local NetworkMessageTypes = require 'lib.network_message_types'
local Warrior = require 'lib.characters.warrior'
local Mage = require 'lib.characters.mage'
local Ranger = require 'lib.characters.ranger'

Player = {}

-- Constructor
--
--
function Player:new(id, name, character_type, pos)
  local obj = {
    id = id,
    name = name,
    character = nil,
    keys_down = {},
    local_player = false
  }

  if character_type == CharacterTypes.Warrior then
    obj.character = Warrior:new(pos, id)
  elseif character_type == CharacterTypes.Mage then
    obj.character = Mage:new(pos)
  elseif character_type == CharacterTypes.Ranger then
    obj.character = Ranger:new(pos)
  end
  self.__index = self
  return setmetatable(obj, self)
end

function Player:load(bind_keys)
  if bind_keys then
    self.local_player = true;
    function love.keypressed(key)
      self.keys_down[key] = true
      client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    function love.keyreleased(key)
      self.keys_down[key] = nil
      client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    function love.mousepressed(x, y, button)
      self.keys_down['m' .. button] = true
      client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    function love.mousereleased(x, y, button)
      self.keys_down['m' .. button] = nil
      client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    camera:lookAt(self.character.pos.x, self.character.pos.y)
  end
  self.character:load()
  world:add(self, self.character.pos.x + offsetX, self.character.pos.y + offsetY, self.character.body.width, self.character.body.height)
end

function Player:update(dt)
  self.character:idle()

  if self.keys_down['w'] then
    self.character:run(Orientations.Up)
    self.character.pos.x, self.character.pos.y = self:move(self.character.pos.x, self.character.pos.y - self.character.speed * dt)
  end
  if self.keys_down['a'] then
    self.character:run(Orientations.Left)
    self.character.pos.x, self.character.pos.y = self:move(self.character.pos.x - self.character.speed * dt, self.character.pos.y)
  end
  if self.keys_down['s'] then
    self.character:run(Orientations.Down)
    self.character.pos.x, self.character.pos.y = self:move(self.character.pos.x, self.character.pos.y + self.character.speed * dt)
  end
  if self.keys_down['d'] then
    self.character:run(Orientations.Right)
    self.character.pos.x, self.character.pos.y = self:move(self.character.pos.x + self.character.speed * dt, self.character.pos.y)
  end

  if self.keys_down['m1'] then
    local x,y = camera:mousePosition()
    self.character:auto_attack(x,y)
  end

  if self.local_player then
    local dx,dy = self.character.pos.x - camera.x, self.character.pos.y - camera.y;
    camera:move(dx, dy)
  end

  self.character:update(dt)
end

function Player:move(goalX, goalY)
  local actualX, actualY, cols, len = world:move(self, goalX + offsetX, goalY + offsetY);
  return actualX - offsetX, actualY - offsetY
end

function Player:draw()
  love.graphics.setColor(0,0,0);
  love.graphics.print(self.name, self.character.pos.x, self.character.pos.y - 25)
  self.character:draw()
end

function Player:destroy()
  -- implement
end

return Player

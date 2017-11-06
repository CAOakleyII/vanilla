local Orientations = require 'lib.orientations'
local CharacterTypes = require 'lib.character_types'
local NetworkMessageTypes = require 'lib.network_message_types'
local Warrior = require 'lib.warrior'
local Mage = require 'lib.mage'
local Ranger = require 'lib.ranger'

Player = {}

-- Constructor
--
--
function Player:new(id, name, character_type)
  local obj = {
    id = id,
    name = name,
    character = nil,
    keys_down = {}
  }

  if character_type == CharacterTypes.Warrior then
    obj.character = Warrior:new()
  elseif character_type == CharacterTypes.Mage then
    obj.character = Mage:new()
  elseif character_type == CharacterTypes.Ranger then
    obj.character = Ranger:new()
  end
  self.__index = self
  return setmetatable(obj, self)
end

function Player:load(bind_keys)
  if bind_keys then
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
  end
  self.character:load()
end

function Player:update(dt)
  if self.keys_down['w'] then
    self.character:run()
    self.character.pos.y = self.character.pos.y - 5
  elseif self.keys_down['a'] then
    self.character:run()
    self.character.pos.x = self.character.pos.x - 5
  elseif self.keys_down['s'] then
    self.character:run()
    self.character.pos.y = self.character.pos.y + 5
  elseif self.keys_down['d'] then
    self.character:run()
    self.character.pos.x = self.character.pos.x + 5
  else
    self.character:idle()
  end

  if self.keys_down['m1'] then
    -- self.character:attack()
  end
  self.character:update(dt)
end

function Player:draw()
  love.graphics.print(self.name, self.character.pos.x - 8, self.character.pos.y - 20)
  self.character:draw()
end

function Player:destroy()
  --implement
end

return Player

local Orientations = require 'lib.orientations'
local CharacterTypes = require 'lib.character_types'
local NetworkMessageTypes = require 'lib.network_message_types'
local Warrior = require 'lib.characters.warrior'
local Mage = require 'lib.characters.mage'
local Ranger = require 'lib.characters.ranger'
local Camera = require 'hump.camera'
Player = {}

-- Constructor
--
--
function Player:new(id, name, character_type, pos)
  local obj = {
    id = id,
    name = name,
    character = nil,
    keys_down = {}
  }

  if character_type == CharacterTypes.Warrior then
    obj.character = Warrior:new(pos)
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
    self.camera = Camera(self.character.pos.x, self.character.pos.y)
  end
  self.character:load()
end

function Player:update(dt)

  if self.keys_down['w'] then
    self.character:run(Orientations.Up)
    self.character.pos.y = self.character.pos.y - self.character.speed
  elseif self.keys_down['a'] then
    self.character:run(Orientations.Left)
    self.character.pos.x = self.character.pos.x - self.character.speed
  elseif self.keys_down['s'] then
    self.character:run(Orientations.Down)
    self.character.pos.y = self.character.pos.y + self.character.speed
  elseif self.keys_down['d'] then
    self.character:run(Orientations.Right)
    self.character.pos.x = self.character.pos.x + self.character.speed
  else
    self.character:idle()
  end

  if self.keys_down['m1'] then
    self.character:attack()
  end


  if self.camera then
    print ('camera')
    local dx,dy = self.character.pos.x - self.camera.x, self.character.pos.y - self.camera.y
    self.camera:move(dx, dy)
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

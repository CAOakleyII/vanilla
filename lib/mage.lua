local CharacterTypes = require 'lib.character_types'

Mage = {}

-- Constructor
--
--
function Mage:new()
  local obj = {
    type = CharacterTypes.Mage,
    pos = {
      x = 200,
      y = 200
    }
  }

  self.__index = self
  return setmetatable(obj, self)
end

function Mage:load()

end

function Mage:draw()

end

function Mage:update(dt)

end

return Mage

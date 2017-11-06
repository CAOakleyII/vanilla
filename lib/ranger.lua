local CharacterTypes = require 'lib.character_types'

Ranger = { }

-- Constructor
--
--
function Ranger:new()
  local obj = {
      type = CharacterTypes.Ranger,
      pos = {
        x = 200,
        y = 200
      }
  }
  self.__index = self
  return setmetatable(obj, self)
end

function Ranger:load()

end

function Ranger:draw()

end

function Ranger:update(dt)

end

return Ranger

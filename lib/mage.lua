local CharacterTypes = require 'lib.character_types'

Mage = {
  type = CharacterTypes.Mage,
  pos = {
    x = 200,
    y = 200
  }
};

-- Constructor
--
--
function Mage:new(obj)
  obj = obj or {};
  setmetatable(obj, self);
  self.__index = self;
  return obj;
end

function Mage:load()

end

function Mage:draw()

end

function Mage:update(dt)

end

return Mage;

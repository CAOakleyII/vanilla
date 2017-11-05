local CharacterTypes = require 'lib.character_types'

Ranger = {
  type = CharacterTypes.Ranger,
  pos = {
    x = 200,
    y = 200
  }
};

-- Constructor
--
--
function Ranger:new(obj)
  obj = obj or {};
  setmetatable(obj, self);
  self.__index = self;
  return obj;
end

function Ranger:load()

end

function Ranger:draw()

end

function Ranger:update(dt)

end

return Ranger;

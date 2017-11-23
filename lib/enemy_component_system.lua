local Zombie = require 'lib.enemies.zombie'

local EnemyComponentSystem = {}

function EnemyComponentSystem:new()
  local obj = {
    enemies = {}
  }
  self.__index = self
  return setmetatable(obj, self)
end

function EnemyComponentSystem:load(m)
  -- load in enemies and init objects
  for k, object in pairs(m.objects) do
    if object.properties.EnemyType == "Zombie" then
      local enemy = Zombie:new({ x = object.x, y = object.y })
      enemy:load()
      table.insert(self.enemies, enemy)
    end
  end

  -- Remove unneeded enemy layer
  m:removeLayer("Enemies")
end

return EnemyComponentSystem

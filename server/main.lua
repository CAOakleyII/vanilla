package.path = package.path ..
';./lib/?.lua;../server/?.lua;' ..
'./packages/msgpack/?.lua;' ..
'./packages/socket/?.lua;' ..
'./packages/uuid/?.lua;';

local sti = require "packages.sti"
local Server = require 'server.server';
local NetworkMessageTypes = require 'lib.network_message_types'
local sti = require "packages.sti"
local bump = require "packages.bump.bump"
local Camera = require 'packages.hump.camera'
local Zombie = require 'lib.enemies.zombie'
camera = Camera()
print "Starting server..."

server = Server:new();


function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      debug.debug()
   end
end

function love.load()
  offsetX = camera.x
  offsetY = camera.y
  map = sti("assets/tutorial_island.lua", { "bump" }, offsetX, offsetY)
  world = bump.newWorld(32)

  -- Prepare collision objects
	map:bump_init(world)
  -- load in enemies and init objects
  enemies = {};
  for k, object in pairs(map.objects) do
    if object.properties.EnemyType == "Zombie" then
      local enemy = Zombie:new({ x = object.x, y = object.y })
      table.insert(enemies, enemy)
      enemy:load()
    end
  end

  -- Remove unneeded enemy layer
  map:removeLayer("Enemies")


  server:start();
end

function love.update(dt)
  server:receivefrom();

  map:update(dt)

  -- update players
  for k,v in pairs(server.players) do
    if v then
      -- print ('updating')
      v:update(dt);
    end
  end

end

function love.draw()
  camera:attach()

  -- draw map
  map:draw(-camera.x, -camera.y)

  -- draw players
  for k,v in pairs(server.players) do
    if v then
      -- print ('drawing')
      v:draw();
    end
  end

  camera:detach()
end

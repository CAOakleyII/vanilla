local sti = require "packages.sti"
local Server = require 'server.server';
local NetworkMessageTypes = require 'lib.network_message_types'
local sti = require "packages.sti"
local bump = require "packages.bump.bump"
local Camera = require 'packages.hump.camera'
local Zombie = require 'lib.enemies.zombie'
local ECS = require 'lib.enemy_component_system'

camera = Camera()
ecs = ECS:new()
server = Server:new();

print "Starting server..."

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

  -- Spawn initial enemies
  ecs:load(map)

  -- Prepare collision objects
	map:bump_init(world)

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

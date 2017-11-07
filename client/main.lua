local Client = require 'client.client';
local ViewManager = require 'gui.view_manager';
local character_select = require 'gui.character_select';
local sti = require "packages.sti"
local bump = require "packages.bump.bump"
local Camera = require 'packages.hump.camera'
local Zombie = require 'lib.enemies.zombie'

camera = Camera()
client = Client:new();
view_manager = ViewManager:new()

function love.quit()
  client:destroy();
end

function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      debug.debug()
   end
end

function love.load()
  view_manager:show(character_select)
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

end

function love.update(dt)
  -- receive network updates
  client:receive()

  if client.player then
    map:update(dt)
    client.player:update(dt)

    -- update players
    for k,v in pairs(client.players) do
      if v then
        v:update(dt)
      end
    end

    -- update enemies
    for k,v in pairs(enemies) do
      if v then
        v:update(dt)
      end
    end

  end

end

function love.draw()
  if client.player then
    camera:attach()

    -- draw map
    map:draw(-camera.x, -camera.y)

    -- draw players
    for k,v in pairs(client.players) do
      if v then
        v:draw();
      end
    end

    -- draw enemies
    for k,v in pairs(enemies) do
      if v then
        v:draw()
      end
    end

    -- draw main player
    client.player:draw()
    camera:detach()

    --map:bump_draw(world, -camera.x, -camera.y)
  end

  view_manager:show();
end

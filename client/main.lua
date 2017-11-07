local Client = require 'client.client';
local ViewManager = require 'gui.view_manager';
local character_select = require 'gui.character_select';
local sti = require "packages.sti"

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
  view_manager:show(character_select);
  map = sti("assets/tutorial_island.lua")
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
        v:update(dt);
      end
    end
  end

end

function love.draw()
  if client.player then

    client.player.camera:attach()
    -- draw map
    map:draw()

    -- draw players
    for k,v in pairs(client.players) do
      if v then
        v:draw();
      end

    end
    client.player.camera:detach()

    client.player.camera:attach()
    -- draw main player
    client.player:draw()
    client.player.camera:detach()
  end

  view_manager:show();
end

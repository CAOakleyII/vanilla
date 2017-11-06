local Client = require 'client.client';
local ViewManager = require 'gui.view_manager';
local character_select = require 'gui.character_select';

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
end

function love.update(dt)
  if client.player then
    client.player:update(dt)
  end

  -- update players
  for k,v in pairs(client.players) do
    if v then
      print ('updating')
      v:update(dt);
    end
  end

end

function love.draw()
  if client.player then
    client.player:draw()
  end

  -- draw players
  for k,v in pairs(client.players) do
    if v then
      print ('drawing')
      v:draw();
    end
  end

  view_manager:show();
end

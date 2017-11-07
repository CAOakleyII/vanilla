package.path = package.path ..
';./lib/?.lua;../server/?.lua;' ..
'./packages/msgpack/?.lua;' ..
'./packages/socket/?.lua;' ..
'./packages/uuid/?.lua;';

local sti = require "packages.sti"
local Server = require 'server.server';
local NetworkMessageTypes = require 'lib.network_message_types'
print "Starting server..."

server = Server:new();


function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      debug.debug()
   end
end

function love.load()
  server:start();
end

function love.update(dt)
  server:receivefrom();

  -- update players
  for k,v in pairs(server.players) do
    if v then
      -- print ('updating')
      v:update(dt);
    end
  end

end

function love.draw()
  -- draw players
  for k,v in pairs(server.players) do
    if v then
      -- print ('drawing')
      v:draw();
    end
  end
end

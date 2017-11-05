package.path = package.path ..
';./lib/?.lua;../server/?.lua;' ..
'./packages/msgpack/?.lua;' ..
'./packages/socket/?.lua;' ..
'./packages/uuid/?.lua;';


local Server = require 'server.server';
local NetworkMessageTypes = require 'lib.network_message_types'
print "Starting server..."

server = Server:new();
server:start();

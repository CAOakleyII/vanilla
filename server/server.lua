local socket = require "socket"
local mp = require "MessagePack"
local NetworkMessageTypes = require 'lib.network_message_types'
local Player = require 'lib.player'

Server = {
  port = 8080,
  address = '*',
  running = false,
  players = {},
  udp = socket.udp()
}

Server.__index = Server;
-- Constructor
--
--
function Server:new(obj)
  obj = obj or {};
  setmetatable(obj, Server)
  return obj;
end

function Server:start()
  self.udp:settimeout(0);
  self.udp:setsockname(self.address, self.port);
  self.running = true;
  print ("server started on", self.address, self.port);
  while true do
    self:receivefrom()

    -- update players
     for k,v in pairs(self.players) do
       if v then
         v:update(dt);
       end
     end
  end
end

function Server:broadcast(player, type, data)
  for k,v in pairs(self.players) do
    if player.id ~= v.id then
      self:sendto(v, type, data)
    end
  end
end

function Server:sendto(player, type, data)
  local msg = {
    type = type,
    data = data
  }
  if type == NetworkMessageTypes.OnConnected then
    print (player.ip)
  end

  local packed_data = mp.pack(msg);
  local success, err = self.udp:sendto(packed_data, player.ip, player.port);
  if not success then
    print(err)
  end
end

function Server:receivefrom()
  local packed_data, ip, port = self.udp:receivefrom()
  if packed_data then
    self:receiveMsg(packed_data, ip, port);
  end
end

function Server:receiveMsg(msg, ip, port)
  local data = mp.unpack(msg)
  if data.type == NetworkMessageTypes.OnConnected then
    self:onConnected(data.data, ip, port)
  elseif data.type == NetworkMessageTypes.OnDisconnected then
    self:onDisconnected(data.data, ip, port)
  elseif data.type == NetworkMessageTypes.OnPlayerInput then
    self:onPlayerInput(data.data, ip, port);
  end
end

function Server:onConnected(player, ip, port)
  local server_player = Player:new({
    id = player.id,
    name = player.name
  }, player.character);
  server_player.ip = ip;
  server_player.port = port;
  self.players[player.id .. ip .. port] = server_player;
  self.players[player.id .. ip .. port]:load();
  print ('player connected: ' .. player.id .. ip .. port)

  self:broadcast(server_player, NetworkMessageTypes.OnConnected, player);
end

function Server:onDisconnected(id, ip, port)
  local server_player = self.players[id .. ip .. port];
  print ('player disconnected: ' .. id .. ip .. port)
  self:broadcast(server_player, NetworkMessageTypes.OnDisconnected, id);
  self.players[id .. ip .. port] = nil;

end

function Server:onPlayerInput(data, ip, port)
  local server_player = self.players[data.id .. ip .. port];
  if server_player then
    server_player.keys_down = data.keys;
    self.players[data.id .. ip .. port] = server_player;
    self:broadcast(server_player, NetworkMessageTypes.OnPlayerInput, data);
  end
end

return Server;

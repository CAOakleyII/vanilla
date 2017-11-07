local mp = require "packages.msgpack.MessagePack"
local socket = require "socket"
local NetworkMessageTypes = require 'lib.network_message_types'
local uuid = require 'packages.uuid.uuid'
Client = {}

-- Constructor
--
-- 159.203.98.173
function Client:new()
  local obj = {
      address = "localhost",
      port = 8080,
      connected = false,
      udp = socket.udp(),
      player = nil,
      players = {}
  }
  self.__index = self
  return setmetatable(obj, self)
end

function Client:connect(player)
  uuid.seed()
  player.id = uuid()
  self.udp:settimeout(0)
  self.udp:setpeername(self.address, self.port)
  self.connected = true
  self.player = Player:new(player.id, player.name, player.character);
  self:send(NetworkMessageTypes.OnConnected, player)
end

function Client:send(type, data)
  if not self.connected then
    return false
  end
  local msg = {
    type = type,
    data = data
  }
  self.udp:send(mp.pack(msg))
end

function Client:receive()
  local packed_data = self.udp:receive()
  if packed_data then
    self:receiveMsg(packed_data)
  end
end

function Client:receiveMsg(msg)
  local data = mp.unpack(msg)
  if data.type == NetworkMessageTypes.OnConnected then
    self:onConnected(data.data)
  elseif data.type == NetworkMessageTypes.OnDisconnected then
    self:onDisconnected(data.data)
  elseif data.type == NetworkMessageTypes.OnPlayerInput then
    self:onPlayerInput(data.data)
  end
end


function Client:onConnected(player)
  print('player connected')
  local client_player = Player:new(player.id, player.name, player.character, player.pos)
  client_player:load()
  self.players[player.id] = client_player
end

function Client:onDisconnected(id)
  local client_player = self.players[id]
  self.players[id] = nil
  if client_player then
    client_player:destroy()
  end
end

function Client:onPlayerInput(data)
  if self.players[data.id] then
    self.players[data.id].keys_down = data.keys
  end
end

function Client:destroy()
  if self.connected then
    self:send(NetworkMessageTypes.OnDisconnected, self.player.id)
    self.udp:close()
    self.connected = false
  end
end

return Client

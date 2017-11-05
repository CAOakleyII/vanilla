echo off
echo "Starting Server"
copy server\main.lua main.lua
copy server\conf.lua conf.lua
love . --console
del main.lua
del conf.lua

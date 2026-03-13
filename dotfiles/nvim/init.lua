-- Make local LuaRocks (Lua 5.1) visible to Neovim BEFORE loading plugins
local home = (vim and vim.loop and vim.loop.os_homedir()) or os.getenv("HOME")
package.path = table.concat({
  package.path,
  home .. "/.luarocks/share/lua/5.1/?.lua",
  home .. "/.luarocks/share/lua/5.1/?/init.lua",
}, ";")
package.cpath = table.concat({
  package.cpath,
  home .. "/.luarocks/lib/lua/5.1/?.so",
}, ";")

-- Optional: if available, this adds any extra LuaRocks paths cleanly
pcall(require, "luarocks.loader")

-- then bootstrap Lazy/plugins
require("config.lazy")

-- update from github and run

local url = "https://raw.githubusercontent.com/AnnikenYT/cc-mek-fusion/refs/heads/main/controller/controller.lua"
local filename = "controller.lua"

fs.delete(filename)
shell.execute("wget", url, filename)
shell.run(filename)
-- update from github and run

local url = "https://raw.githubusercontent.com/AnnikenYT/cc-mek-fusion/refs/heads/main/commandline/cmd.lua"
local filename = "cmd.lua"

fs.delete(filename)
shell.execute("wget", url, filename)
shell.run(filename)
-- update from github and run

local executable = "controller.lua"

local urls = {
{
    url = "https://raw.githubusercontent.com/AnnikenYT/cc-mek-fusion/refs/heads/main/controller/controller.lua",
    filename = "controller.lua"
},
{
    url = "https://raw.githubusercontent.com/Ictoan42/CCLogger/refs/heads/main/CCLogger.lua",
    filename = "CCLogger.lua"
}
}

for _, file in ipairs(urls) do
    fs.delete(file.filename)
    shell.execute("wget", file.url, file.filename)
end

shell.run(executable)
-- update from github and run

local executable = "cmd.lua"

local urls = {
{
    url = "https://raw.githubusercontent.com/AnnikenYT/cc-mek-fusion/refs/heads/main/commandline/cmd.lua",
    filename = "cmd.lua"
}
}

for _, file in ipairs(urls) do
    fs.delete(file.filename)
    shell.execute("wget", file.url, file.filename)
end

shell.run(executable)
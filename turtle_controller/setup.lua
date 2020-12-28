files = {
	["setup/controller/uninstall"] = "rMKTUfNj",
	["setup/controller/run"] = "kkbaxRJb",
	["setup/loader/load_turtle_square"] = "wgixi8GY",
	["setup/loader/load_turtle_line"] = "kgiv2Nu4",
	["setup/loader/startup"] = "X4GnLjax",
	["setup/miner/startup"] = "nbspFbFt",
	["setup/miner/wireless_startup"] = "WjrTu2N0",
	["setup/miner/dig"] = "XdsJ3i6E",
	["setup/miner/wireless"] = "1Ftn2jbV"
}

local curr = 1
local total = 9

for name, link in pairs(files) do
	print("Installing...(" .. curr .. "/" .. total .. ")")
	shell.run("pastebin", "get", link, name)
	os.sleep(0.5)
	curr = curr + 1
end

print("Done!")

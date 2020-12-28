rednet.open("left")

while true do
	id, params = rednet.receive()
	print("Message Received Over RedNet")
	if(params ~= nil) then
		if(params[0] == "run") then
			shell.run(unpack(params))
			return
		end
		if(params[0] == "install") then
			shell.run("delete", params[2])
			shell.run("pastebin", "get", params[1], params[2])
		end
		if(params[0] == "delete") then
			shell.run("delete", params[1])
		end
	end
end
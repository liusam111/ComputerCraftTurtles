rednet.open("right")

if(#arg == 1) then
	rednet.broadcast(arg)
else
	print("Usage: uninstall <program_name>")
end

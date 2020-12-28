rednet.open("right")

if(#arg ~= 0) then
	rednet.broadcast(arg)
else
	print("Usage: run <program_name> <args>")
end

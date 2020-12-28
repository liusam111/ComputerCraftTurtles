files = {
 "load_turtle_line",
 "load_turtle_square
}

print("Loading turtle with startup program...")
shell.run("label", "set", '"Fuel Loader"')

for fileIndex = 1, #files, 1 do
    fileName = files[fileIndex]
    fs.delete(fileName)
    fs.copy("disk/" .. fileName, fileName) 
end
 
turtle.select(1)
turtle.refuel(1)
turtle.forward()
turtle.turnRight()

for i = 1, 16, 1 do
    turtle.forward()
end
shell.run("reboot")

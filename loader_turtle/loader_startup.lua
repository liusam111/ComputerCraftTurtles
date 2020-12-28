print("Loading turtle with startup program...")
shell.run("label", "set", '"Fuel Loader"')

fs.delete("load_turtle_line")
fs.delete("load_turtle_square")
fs.copy("disk/load_turtle_line", "load_turtle_line")
fs.copy("disk/load_turtle_square", "load_turtle_square")

 
turtle.select(1)
turtle.refuel(1)
turtle.forward()
turtle.turnRight()

for i = 1, 16, 1 do
    turtle.forward()
end
shell.run("reboot")
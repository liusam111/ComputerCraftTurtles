print("Loading turtle with startup program...")
shell.run("label", "set", "Slave")

fs.delete("wireless")
fs.delete("startup")
fs.delete("dig")
fs.copy("disk/wireless", "wireless")
fs.copy("disk/wireless_startup", "startup")
fs.copy("disk/dig", "dig")

turtle.select(1)
turtle.refuel(1)
turtle.forward()
turtle.forward()
turtle.turnRight()

for i = 1, 16, 1 do
    turtle.forward()
end
shell.run("reboot")
--[[
	TITLE:	BUDGET JD FLEET CONTROLLER
	AUTHOR:	SHADYFOX
--]]

mem = {
	jds = {
		["jd-tail"] = {nb = 1, target = {}},
		["jd-head"] = {nb = 0, target = {}},
	}
}

--	Constants
local axis = "z"
local direction = -1
local JDradius = 6

--When receive set, do set.
set = function(target)
	--	send coordinates to each jumpdrive
	for name, value in pairs(mem.jds) do
		offset = (value.nb*direction*(JDradius*2 + 1)) 
		mem.jds[name].target  = {x = target["x"], y = target["y"], z = target[axis] - offset} -- make a new array with new coordinates.
	end
end

send = function(send)
	for name, value in pairs(mem.jds) do
		digiline_send(name, {command = "set", x = value.target.x, y = value.target.y, z = value.target.z})
		digiline_send(name, {command = "jump"})
		digiline_send("screen",name.."\t: has jumped!\n")
	end
end

--	

--set({x = 6144, y = 5300, z = 33})
--send()

if event.type == "digiline" then
	if event.channel == "master" and event.msg.command == "set" then
    	set(event.msg.target)
    	digiline_send("screen", "New route plotted.\n")
    	digiline_send("screen", event.msg.target.x.."\n")
    	digiline_send("screen", event.msg.target.y.."\n")
    	digiline_send("screen", event.msg.target.z.."\n")
  	end
  	if event.channel == "master" and event.msg.command == "jump" then
    	send()
  	end
end
-- Result
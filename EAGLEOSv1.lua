--[[
	Code For : E.A.G.L.E Sea Mantis
	AUTHOR : shadyfox

	DESCRIPTION : 
		EAGLE V1 was an r2 fuel powered ship with varying radius. Here is the code that ran on it.  
--]]

--	CHANNELS
--local converter = "convert"
local jumpdrive = "jumpdrive"
local screen = "screen"
local keyboard = "keyboard"
local fuelInjector = "fuel"
--	VARABLES
--local convertState = 0		-- initial converter state
local fuelItem = "biofuel:bottle_fuel"

--	COORDINATES
local home = {12677, -1282, -4558}
local moon = {5670, 5300, -730}
local mine = {-4612, 200, 2940}
local phoenix = {9900, 200, 10150}
mem.now = {x = 5670 ,y =5300 ,z = -4558}

--	FUNCTIONS
--[[
local function power(set)	-- POWER INTERFACE 1 => on 0 => off
	if set ~= convertState then
		digiline_send(converter, "toggle")
		convertState = set
	end
end
--]]

--	JUMP-DRIVE
local function jd_jump()	-- JUMP COMMAND
	-- power(1)
	digiline_send(jumpdrive, {command="jump"})
end

local function jd_set_xyz(jdx, jdy, jdz)
  digiline_send(jumpdrive, {command="set", key ="x", value=jdx})
  digiline_send(jumpdrive, {command = "save"})
  digiline_send(jumpdrive, {command="set", key="y", value=jdy})
  digiline_send(jumpdrive, {command = "save"})
  digiline_send(jumpdrive, {command="set", key="z", value=jdz})
  digiline_send(jumpdrive, {command = "save"})
end

local function jd_set_radius(radius)
  digiline_send(jumpdrive, {command="set", key ="radius", value=radius})
  digiline_send(jumpdrive, {command = "save"})
end

-- THIS PART IS WRITTEN BY SX
local echo = function(text, lf)
	digiline_send(screen, text .. (lf and lf or "\n" .. (mem.pwd or '') .. "> "))
end

local reset = function()
  echo("Welcome aboard captain,\n all primary systems... online. ")
end

local parsecommand = function( cmd )
	argstart = string.find(cmd, " ", 1, true)
	-- Use ternary operator to either get substrings or full input string and empty string
	-- Space between command and args will be removed
	return {
		cmd = argstart == nil and cmd or string.sub(cmd, 1, argstart - 1),
		argstr = argstart == nil and "" or string.sub(cmd, argstart + 1, #cmd)
	}
end

local commands = {
	-- cl ( change location )
	cl = function(arg)
		if arg == "home" then
		 jd_set_xyz(12677, -1282, -4558)
  --jd_set_xyz(home)			
echo("Next destination : home")
		elseif arg == "moon" then
			jd_set_xyz(5670, 5400, -730)
			echo("Next destination : moon")
		elseif arg == "mine" then
			jd_set_xyz(-4612, 200, 2950)
			echo("Next destination : mine")	
 elseif arg == "phoenix" then
			jd_set_xyz(9900, 200, 10150)
			echo("Next destination : phoenix")	
		else	
  echo("ERR: Unknown location")
		end
	end,


	-- echo
	echo = function(arg)
    		echo(arg)
 	end,
	
	-- Injectfuel
	inject = function(arg)
		echo("Injecting fuel...")
		digiline_send(fuelInjector, fuelItem)
		digiline_send(fuelInjector, fuelItem)
		digiline_send(fuelInjector, fuelItem)
	end,

	-- jump
	jump = function(arg)
		echo("Jump sequence started...")
		jd_jump()
	end,

	-- set
	set = function(arg)
	end,

	-- sleeve
	sleeve = function(arg)
		if arg == "on" then
			echo("sleeve on")
			jd_set_radius(3)
		elseif arg == "off" then
			echo("sleesve off")
			jd_set_radius(2)
		else
			echo("usage: sleeve on|off")
		end
	end,

 -- r15
	r15 = function(arg)
		if arg == "on" then
			echo("r15 on")
			jd_set_radius(15)
		elseif arg == "off" then
			echo("r15 off")
			jd_set_radius(2)
		else
			echo("usage: sleeve on|off")
		end
	end,
}

--##################################################

--	MAIN
if event.type == "digiline" and event.channel == keyboard then

	-- Parse command, basically divides string to 2 parts cutting at first space
	local cmdinfo = parsecommand( event.msg )

	if commands[cmdinfo.cmd] then
		commands[cmdinfo.cmd](cmdinfo.argstr)
	else
		echo("ERR: Unknown command")
	end

elseif event.type == "program" then
	reset()
end
--	END MAIN


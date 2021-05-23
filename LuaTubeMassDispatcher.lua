-- ORIGINAL CODE: int
-- REWRITE: shadyfox
-- TITLE: Lua Tube mass dispatcher

--mem = {} 
-- Uncomment mem={} to reset or program 

threshold = 99999
defaultValue = 1000000000

if mem.targets == nil then 
	mem.targets = {
--		white = 0,
--		black = 0,
--		yellow = 0,
		red = 0,
		blue = 0,
 green = 0,
		default = defaultValue,	-- default is not real but is needed for the code to work.
	} -- Commentout unused
end

--[[
	FUNCTIONS DEINITION
--]]

local function whoHasTheLeast() -- This function returns what target has the less
	least = "default"
	for color, value in pairs(mem.targets) do
		least = value < mem.targets[least] and color or least 
		-- the line can be interpreted as : 
		-- least = <condition> ? if condition is true return <value> : if condition is false return <value>
	end
	return least
end

local function isThresholdReached() -- This function returns true if only every mem.targets ecceeds the threshold
	isReached = true 
	for color, value in pairs(mem.targets) do 
		isReached = ( value > threshold and isReached )
	end
	return isReached 
end

local function doBringDownValues() -- This function bring down every value by threshold except default
	for color, value in pairs(mem.targets) do
		mem.targets[color] = value - threshold
	end
	mem.targets["default"] = defaultValue -- default needs to stay the same
end

--[[
	MAIN
--]]

if event.item then
	least = whoHasTheLeast()
	digiline_send("screen", least.." has the least\n")
	mem.targets[least] = mem.targets[least] + event.item.count
	return least
end

if event.type == "interrupt" then 
	if isThresholdReached() then
		doBringDownValues()
	end
end

--[[
	INTERUPTS 
--]]
interrupt(5)

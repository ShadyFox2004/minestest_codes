--[[
	AUTHOR: shadyfox
	TITLE: PHONIX v2 Fuel Injector Module
	DESCRIPTION: Inject send the fuel injection to the motor if recives "inject
	NOTE: This code is unix standard, it does onething and does it well. It is ment to be use in conjonction with other litle codes like this in the PHOENIX super computer
--]]

-- CONSTANT
fuelInjector = "fuel"
fuelItem = "biofuel:bottle_fuel"

-- EVENT
if event.type == "digiline" and event.msg == "inject" then
	for i=1,9 do digiline_send(fuelInjector, fuelItem) end
end

--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function init()

	monster.setAggressive(false)
	monster.setDamageOnTouch(false)
	monster.setDamageBar("none");
	monster.setInteractive(false)
	
	monster.type()
	monster.seed()
	monster.uniqueParameters()
	monster.familyIndex()
	monster.level()
	
	--self.ownerid = config.getParameter("masterId")
	--self.sayMessage = config.getParameter("sayMessage")
	
	useThisType = config.getParameter("vsoType")
	
	once = 0;
end

function update(dt)
	if once == 0 then 
		
		local vehicleParams = {
			ownerKey = nil,
			startHealthFactor = 1.0,
			fromItem = true,
			initialFacing = 1;	--Random selection?
		}	
		if math.random() > 0.5 then
			vehicleParams.initialFacing = -1;
		else
			vehicleParams.initialFacing = 1;
		end
		
		local placepos = mcontroller.position()
		
		local spawnedone = world.spawnVehicle( useThisType, placepos, vehicleParams )--, [Json overrides])
		
		if spawnedone == nil then
			sb.logInfo( "VSO monster spawner at %s failed to spawn %s", placepos, useThisType )
		else
			world.sendEntityMessage( spawnedone, "vsoCreatedMonster", nil, placepos )
		end
		
		--world.callScriptedEntity( entity.id(), "status.addEphemeralEffect", "vsokill", 1.0, self.ownerid );
		status.setResource("health", -100)

		once = 1; 
	end
end


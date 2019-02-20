--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function init()

	owner = effect.sourceEntity();

	mcontroller.setVelocity({0, 0})	
	
	targetOffset = nil;
	
	if owner ~= nil then
		if world.entityExists( owner ) then
		
			local pos = world.entityPosition( owner );
			mcontroller.setPosition( pos );
			
			--effect.addStatModifierGroup({{stat = "invulnerable", amount = 1}})
		   
			message.setHandler("targetOffset",
				function(_, _, arg, arg2 )
					targetOffset = arg;
					if arg2 > 0 then kill() end
				end)
		else
			kill();
		end
	else
		kill();
	end
end

function kill()
	--effect.addStatModifierGroup({{stat = "invulnerable", amount = 0}})
	status.setResource("health", -10)
	effect.expire();
end

function update(dt)
	if owner ~= nil then
		if world.entityExists( owner ) then
			local pos = world.entityPosition( owner ) 
			if targetOffset ~= nil then
				mcontroller.setPosition( { pos[1] + targetOffset[1], pos[2] + targetOffset[2] } );
			else
				mcontroller.setPosition( pos );
			end
			if effect.duration() < 1 then
				effect.modifyDuration( 1 )
			end
		else
			kill();
		end
	else
		kill();
	end
end

function uninit()
end

--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function init()

	owner = effect.sourceEntity();
	duration = 6;	--Adjust as needed

	mcontroller.setVelocity({0, 0})	
	
	mouthOffset = nil;
	
	if owner ~= nil then
		if world.entityExists( owner ) then
		
			local pos = world.entityPosition( owner );
			mcontroller.setPosition( pos );
			
			effect.addStatModifierGroup({{stat = "invulnerable", amount = 1}})
		   
			message.setHandler("mouthPosition",
				function(_, _, arg )
					mouthOffset = arg;
					duration = 6;
				end)
		else
			kill();
		end
	else
		kill();
	end
end

function kill()
	effect.addStatModifierGroup({{stat = "invulnerable", amount = 0}})
	status.setResource("health", -10)
	effect.expire();
end

function update(dt)
	duration = duration - dt
	if owner ~= nil then
		if world.entityExists( owner ) then
			local pos = world.entityPosition( owner ) 
			if mouthOffset ~= nil then
				mcontroller.setPosition( { pos[1] + mouthOffset[1], pos[2] + mouthOffset[2] } );
			else
				mcontroller.setPosition( pos );
			end
			if duration < 1 then
				kill();
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

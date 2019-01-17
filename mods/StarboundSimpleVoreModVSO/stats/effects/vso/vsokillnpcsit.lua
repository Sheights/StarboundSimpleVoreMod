--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function dothing()
	status.setResource("stunned", 0 )
	status.setResource("health", 0 )
	status.overConsumeResource( "health", 2*status.resourceMax( "health" ) )	

	if world.isNpc( entity.id() ) then
		world.callScriptedEntity( entity.id(), "npc.resetLounging" );
	else
		--world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", nil, nil )
		--sb.logInfo( "Not a npc?" );
		effect.expire()
	end
	
	--status.removeEphemeralEffect("");
	--status.clearPersistentEffects();
end

function init()
	dothing()
end

function update(dt)
	dothing()
end

function uninit()

end

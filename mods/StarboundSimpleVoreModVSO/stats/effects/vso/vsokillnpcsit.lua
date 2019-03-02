--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function dothing()

	effect.setParentDirectives("multiply=00000000")	--Works always. Hm.
	
	status.removeEphemeralEffect( "vsokeepsit" );
	status.overConsumeResource( "health", 99999999 );-- "health", 2*status.resourceMax( "health" ) )	
	
end

function init()

	effect.setParentDirectives("multiply=00000000")	--Works always. Hm.
	
	if world.isNpc( entity.id() ) then
		status.setResource("stunned", 0 )	--only for npcs
		world.callScriptedEntity( entity.id(), "npc.resetLounging" );
	else
		--world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", nil, nil )
		--sb.logInfo( "Not a npc?" );
		--effect.expire()
	end
	
	--status.clearPersistentEffects();
	status.removeEphemeralEffect( "vsokeepsit" );
	status.setResource("health", 0 )
	status.overConsumeResource( "health", 99999999 );--2*status.resourceMax( "health" ) )	
	
	dothing()
end

function update(dt)
	dothing()
end

function uninit()

end


function hit( hitvictim )

	local truevicid = projectile.getParameter( "voreVictim", -1 );	
	
	if truevicid == hitvictim then
	
		local voretype = projectile.getParameter( "voreType", 0 );
		--Get ate!
		world.sendEntityMessage( truevicid, "voreCaptureBegin", voretype, projectile.sourceEntity() );
	else
		--Must turn that crap OFF
		world.sendEntityMessage( hitvictim, "voreCaptureDisable", hitvictim, projectile.sourceEntity() );
	end
	
	--local truevicid = projectile.power();--projectile.getParameter( "power", -1 );
	
	--"..tostring( entity.id() ).."
	
	--sb.logInfo( "PROJO () voreAttack hit "..tostring( hitvictim ).." e:"..tostring( projectile.sourceEntity() ).." v:"..tostring( truevicid ) );

	--sb.logInfo( genTableString( "self(projectile) ", self ) );
	
		--if truevicid < 0 then
		--	world.callScriptedEntity( world.entityUniqueId( truevicid ), "status.addEphemeralEffect", "monstervore", voreduration, projectile.sourceEntity() );
		--else
		--	world.callScriptedEntity( hitvictim, "status.addEphemeralEffect", "monstervore", voreduration, projectile.sourceEntity() );		
		--end
  
		--local takeAction = {
		--	action = "status",
		--	type = "monstervore",
		--	duration = voreduration
		--}
		
		--	Must have a "action" command
		--	"Unknown projectile reap command effect"
		--	action = "effect",		
		--	"status"
		--KNOWN commands are:
		--	"action" : "projectile" (shoot another projectil)
		--	"action" : "particle" (emit particle)
		--	"action" : "config", (read actions from another file)
		--	"action" : "loop", (animation)
		--	"action" : "light", (MAKE A LIGHT FLASH)
		--	"action" : "sound" (play a sound)
		--		"action" : "sound",
		--		"options" : [ "/sfx/projectiles/goocluster_pop.ogg" ]
		--	"action" : "tile", (Add a tile to the world)
		--		"materials" : [
        --		{"kind" : "throwingblock"}
		--		]
		--	"action" : "liquid"	(add liquid to the world!)
		--
		
		--projectile.processAction( takeAction );
		
		--[[
		local mergeOptions = {
			statusEffects = {
			{
				effect = voreeffect,
				duration = temp
			}},
			power = victim
		}
		]]--
			
	--else
		--projectile.die();	--do NOT hit target (uh! interesting problem if people are stacked together...)
		
	--end
	
	--Let the predator know they hit me
	--world.sendEntityMessage( self.ownerPred, "voreAttackStatusMessage", self.voreType, hitvictim );
	
	--Can precheck stuff BEFORE hit is processed? Hm!
	--This is GREAT! but what do we return here?
	
	--Can we apply a status effect to the hitvictim?
	--[[
	--mcontroller.mass();
	local mergeOptions = {
		statusEffects = {
		{
			effect = voreeffect,
			duration = temp
	}}}
	
	projectile.processAction( mergeOptions );
	]]--
end

function uninit()
	if projectile.collision() then
		--sb.logInfo( "voreAttack projectile.collision" );
		--UHM!
		--world.sendEntityMessage( projectile.sourceEntity(), "voreAttackStatusMessage", 0, -1 );
	else
		--sb.logInfo( "voreAttack projectile.fadedout" );
		world.sendEntityMessage( projectile.sourceEntity(), "voreAttackStatusMessage", -2, -1 );
	end
end

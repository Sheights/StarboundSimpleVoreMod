require "/scripts/behavior.lua"
require "/scripts/vec2.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/notification.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/status.lua"

function init()

	message.setHandler("voreCaptureDisable", function(_, _, mistake )	--Stop eating the thing
		uninit();
    end)
	
	self.destroyself = false;
	
	self.ownerPred = effect.sourceEntity();
	self.ownerPrey = entity.id();
		
	if world.entityExists( self.ownerPred ) and world.entityExists( self.ownerPrey ) then	--Protection in case effect lingers (player quits while vored)

		voreEffectsApply();
	else
		uninit();
	end
	
end

function update(dt)

	--Effect does NOT go away... interesting. HOWEVER, this does not work for whatever reason
	--if effect.duration() < 10 and effect.duration() > 0 then	--hack to protect against expire
	--	effect.modifyDuration( 10 - effect.duration() );
	--end

	if world.entityExists( self.ownerPred ) then 
			
		mcontroller.controlModifiers({	--From paralysis
			facingSuppressed = true,
			movementSuppressed = true
		})
		mcontroller.setVelocity({0, 0});

		vector = world.entityPosition( self.ownerPred )
		
		if vector ~= nil then	
		
			mcontroller.setPosition( vector )	--This is important for the camera, you can add offsets to make it interesting

		else
			self.destroyself = true;
		end
		
	else
	
		self.destroyself = true;
	end
	
	if self.destroyself then
		effect.expire();
		uninit();
	end

end

function uninit()

	world.sendEntityMessage( self.ownerPred, "voreAttackStatusMessage", -2, self.ownerPrey );	--Send predator a message, and tell them too bad

	effect.expire();
	voreEffectsUnapply();
end

function voreEffectsApply()

	mcontroller.clearControls();	--HACK remove control inputs
	
	mcontroller.setVelocity({0, 0});
	
	mcontroller.controlModifiers({	--Taken from "tarslow.lua" to stop player/things from moving about! Nice. Undocumented.
		groundMovementModifier = 0.0,
		speedModifier = 0.0,
		airJumpModifier = 0.0,		--Disable air jump stuff
		facingSuppressed = true,	--From monstercapture.lua and paralysis (cant face, can't move
		movementSuppressed = true	--Can't move
	})
	
	effect.addStatModifierGroup({
		{stat = "invulnerable", amount = 1}	--Taken from invulnerable
		,{stat = "nude", amount = 1}		--From bed
		,{stat = "protection", amount = 100}		--From levitation "Add protection from mobs" and maxprotection
		,{stat = "grit", amount = 1.0}	--from maxprotection
		,{stat = "lavaImmunity", amount = 1}		--All 4 from liquidimmunity
		,{stat = "poisonStatusImmunity", amount = 1}
		,{stat = "fireStatusImmunity", amount = 1}
		,{stat = "iceStatusImmunity", amount = 1}
		,{stat = "electricStatusImmunity", amount = 1}
		,{stat = "stunImmunity", amount = 0}	--from stun
		,{stat = "tarImmunity", amount = 1}
		,{stat = "paralysisImmunity", amount = 0}		
		,{stat = "freezeImmunity", amount = 1}
		,{stat = "tarImmunity", amount = 0}
		,{stat = "breathProtection", amount = 1}	--Interesting problem
		,{stat = "waterImmunity", amount = 1}
		,{stat = "powerMultiplier", effectiveMultiplier = 0}	--this gem is from timefreeze, it makes all player attacks meaningless
		,{stat = "activeMovementAbilities", amount = 1}	--Found in the translocate part! nice. Replaces the setPersistantEffects to disable all techs
		,{stat = "fallDamageMultiplier", amount = 0}	--No fall damage! great!
		--Nope,{stat = "maxEnergy", amount = 0.0}	--Could abuse energy and maxEnergy for a bit, and use it as a meter
		--Nope,{stat = "energy", amount = 0.0}	--Could abuse energy and maxEnergy for a bit, and use it as a meter
		
		--effect.addStatModifierGroup({{stat = "maxEnergy", amount = config.getParameter("energyAmount", 0)}})
		,{stat = "energyRegenPercentageRate", effectiveMultiplier = 0}	--from biomecold
	});
	
	status.setResourcePercentage("energy", 0.0);	--Hm...
  
	--Not sure stunned is doing anything interesting
	if status.isResource("stunned") then	--from paralysis
		status.setResource( "stunned", 1.0 );
	end
	
	effect.setParentDirectives("multiply=00000000");	--Make victim invisible (can do this anytime)
	
	--we do NOT have:
	--	npc
	--	player
	--	objectAnimator
	--	animator
	--	localAnimator
	--we DO have:
	--	entity
	--sb.logInfo( "XMV "..entity.entityType() );
	
	--npc.setLounging(EntityId loungeable, [size_t anchorIndex])
	
	--BUT what can we doooo

	--world.isNPC( );
	--Loss of breath for players
    --status.modifyResource("breath", -status.stat("breathDepletionRate") * dt)
	

	--INTERESTING, if we block regen this sould be fun
    --status.modifyResourcePercentage("energy", status.stat("energyRegenPercentageRate") * dt)
	
	--status.addEphemeralEffects( { 
	--	{effect = "npcacid", duration = effect.duration()} --does the digestion bit, but this should probably be per monster controlled rather than effect.
	--	--, {effect = "intents", duration = effect.duration()} --hides the player
	--	-- "slowlove" which is just a particle effect
	--	
	--}, self.ownerPred );

end

function voreEffectsUnapply()

	--status.removeEphemeralEffect("npcacid")
	--status.removeEphemeralEffect("intents")
	
	effect.expire();
end

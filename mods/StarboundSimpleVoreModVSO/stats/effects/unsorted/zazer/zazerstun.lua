
damageteam = nil
waitforit = 1;

function keepit()

	mcontroller.controlModifiers({
		movementSuppressed = true
		, facingSuppressed = true
		, runningSuppressed = true
		, jumpingSuppressed = true
		, groundMovementModifier = 0.0
		, speedModifier = 0.0
		, airJumpModifier = 0.0
	})  
end

function init()

	effect.setParentDirectives("fade=7733AA=0.25")
	local statgroupid = effect.addStatModifierGroup({
		{stat = "jumpModifier", amount = 0.0},
		{ stat = "protection", amount = 100 },
		{ stat = "grit", amount = 0 },
		{ stat = "invulnerable", amount = 100 }		--HACK for monsters to stop them from hurting you? suppressDamageTimer / touchDamageEnabled exists on monsters...
	})

	--CAN WE DO THIS? have to access: monster or npc or vehicle table to change damage team.
	damageteam = world.entityDamageTeam( entity.id() )
	if damageteam ~= nil then
		world.sendEntityMessage( entity.id(), "vsoChangeDamageTeam", { type="friendly", team=1 } );
	end
	
	keepit();
	
	waitforit = 5;	--hack.
	
end

function update(dt)

	keepit();
	
	if waitforit > 0 then
		waitforit = waitforit - 1;
		if waitforit <= 0 then
			if status ~= nil then
				if status.isResource("stunned") then
					status.setResource("stunned", 100 )	--stunned blocks invulnerable??? dangit!
				end
			end
			waitforit = 0;
		end
	end
	
end

function uninit()
	
	--CAN WE DO THIS? have to access: monster or npc or vehicle table to change damage team.
	if damageteam ~= nil then
		world.sendEntityMessage( entity.id(), "vsoChangeDamageTeam", damageteam );
	end
	
	if status ~= nil then
		if status.isResource("stunned") then
			status.setResource("stunned", 0 )
		end
	end
end

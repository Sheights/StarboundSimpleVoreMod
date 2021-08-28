
damageteam = nil
waitforit = 1;
owner = nil;

function keepit()

	mcontroller.controlModifiers({
		movementSuppressed = true
		, facingSuppressed = true
		, runningSuppressed = true
		, jumpingSuppressed = true
		, groundMovementModifier = 0.0
		, speedModifier = 0.0
		, airJumpModifier = 0.0
		, collisionEnabled = false
		, frictionEnabled = false
		, gravityEnabled = false
	})  
end

function init()

	--victim = entity.id()
	--self.victimtype = entity.entityType();
	owner = effect.sourceEntity();
	--seatindex = config.getParameter( "fixedSeatIndex" )
	
	effect.setParentDirectives("multiply=00000000");   --visible or not? scaling? other things?
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

	--move to owner position? hmmmm
	local bindto = world.entityPosition( owner );
	
	if bindto ~= nil then
		mcontroller.setPosition( bindto );
		mcontroller.setVelocity( {0,0} );
		
	else
		effect.expire();
		return
	end
	
	keepit();
	
	if waitforit > 0 then
		waitforit = waitforit - 1;
		if waitforit <= 0 then
			if status ~= nil then
				if status.isResource("stunned") then
					status.setResource("stunned", 100 )	--stunned blocks invulnerable??? dangit!
					waitforit = 0;
				else
					waitforit = 1;
				end
			else
				waitforit = 1;
			end
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

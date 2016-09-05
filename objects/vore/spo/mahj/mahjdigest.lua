animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

victim = nil
health = nil

lock = false

function init()

  chatOptions = config.getParameter("chatOptions", {})
  gulpLines = config.getParameter("gulpLines", {})
  chatIdleEmpty = config.getParameter("chatIdleEmpty", {})
  chatIdleFull = config.getParameter("chatIdleFull", {})
  rubLines = config.getParameter("rubLines", {})
  
end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if victim ~= nil then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
		
		if ( animState == "idle" or animState == "animation" ) and lock == false then
			animator.setAnimationState("bodyState", "swallow")
			animator.playSound("swallow")
			object.say(gulpLines[math.random(1, #gulpLines)])
		end
		
		if math.random(350) == 1 then
			world.spawnProjectile( "digestprojectile" , object.position(), entity.id(), {0, 0}, false )
		end
		
		if math.random(500) == 1 then
			local people = world.entityQuery( object.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people > 0 and math.random() > 0.5 then
				object.say( chatOptions[ math.random( #chatOptions ) ] )
			elseif #people > 0 then
				object.say( chatIdleFull[ math.random( #chatIdleFull ) ] )
			end
		end
		
		if health < 0.1 and animState == "bellyidle3" then
			animator.setAnimationState("bodyState", "digest")
			lock = true
		elseif health < 0.4 and animState == "bellyidle2" then
			animator.setAnimationState("bodyState", "bellytrans2")
		elseif health < 0.7 and animState == "bellyidle1" then
			animator.setAnimationState("bodyState", "bellytrans1")
		end
		
	else
		if animState == "bellyidle1" or animState == "bellyidle2" or animState == "bellyidle3" then
			animator.setAnimationState("bodyState", "regurgitate")
		end
		
		if math.random(500) == 1 then
			local people = world.entityQuery( object.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people > 1 then
				object.say( chatOptions[ math.random( #chatIdleEmpty ) ] )
			end
		end
		lock = false
	end
end

function onInteraction(args)

	victim = args.sourceId
	
	if world.loungeableOccupied(entity.id()) then
		object.say( rubLines[ math.random( #rubLines ) ] )
	end
	
end
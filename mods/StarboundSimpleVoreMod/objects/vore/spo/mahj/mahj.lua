animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

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
	
		if animState == "idle" or animState == "animation" then
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
		
	else
		if animState == "bellyidle1" then
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
	end
end

function onInteraction(args)

	victim = args.sourceId
	
	if world.loungeableOccupied(entity.id()) then
		object.say( rubLines[ math.random( #rubLines ) ] )
	end
	
end
animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

bellySounds = {	"belly1",
				"belly2",
				"belly3"
}

deathLock=0
health=0

victim = null

function init()

end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
		
		if victim ~= null then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
	
		if animState == "idle" and deathLock == 0 then
			animator.setAnimationState("bodyState", "pickup")
			animator.playSound("swallow")
		elseif animState == "idlefull" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "rub")
			animator.playSound( bellySounds[ math.random( #bellySounds ) ] )
		elseif animState == "idlefull" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "struggle")
			animator.playSound( bellySounds[ math.random( #bellySounds ) ] )
		elseif animState == "idlefull" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "burp")
		elseif animState == "idlefull" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "lickfull")
		end
		
		if animState == "idlefull" and health < .05 then
			animator.setAnimationState("bodyState", "digest")
			deathLock=1
		end

	else
	
		if animState == "idle" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "air")
			do return end
		elseif animState == "idle" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "ear")
			do return end
		elseif animState == "idle" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "call")
			do return end
		elseif animState == "idle" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "lick")
			do return end
		elseif animState == "idlefull" then
			animator.setAnimationState("bodyState", "regurg")
			do return end
		end
		deathLock=0
	end
end

function onInteraction(args)
	victim = args.sourceId
end
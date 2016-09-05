animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

bellySounds = {	"belly1",
				"belly2",
				"belly3"
}

function init()

end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idle" then
			animator.setAnimationState("bodyState", "vicareat")
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
	end
end
animState = "blank"

function init()

end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idlecp" then
			animator.setAnimationState("bodyState", "swallow")
			animator.playSound("swallow")
		elseif animState == "fullcp" and math.random(200) == 1 then
			animator.setAnimationState("bodyState", "full")
		end

	else
	
		if animState == "idlecp" and math.random(100) == 1 then
			animator.setAnimationState("bodyState", "idle1")
			do return end
		elseif animState == "fullcp" then
			animator.setAnimationState("bodyState", "release")
			do return end
		end
		
	end
end
animState = "blank"
lock = true
temp = 0
--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

eatLines = {
}

idleLines = {
}

bellyLines = {
}

function init()

end

function update(dt)
		
	animState = animator.animationState("bodyState")
	temp = math.random(500)
	
	if world.loungeableOccupied(entity.id()) then
		
		if animState == "default" then
			animator.setAnimationState("bodyState", "swallow")
		end
		
		
		
		if temp == 1 and animState == "full" then
			animator.setAnimationState("bodyState", "rub")
		elseif temp == 2 and animState == "full" then
			animator.setAnimationState("bodyState", "struggle")
		elseif temp == 3 and animState == "full" then
			animator.setAnimationState("bodyState", "fullblink")
		end
		
		
	else
		
		if animState == "full" then
			animator.setAnimationState("bodyState", "totail")
		end
		
		if temp == 1 and animState == "default" then
			animator.setAnimationState("bodyState", "blink")
		elseif temp == 2 and animState == "default" then
			animator.setAnimationState("bodyState", "smile")
		end
	end
end
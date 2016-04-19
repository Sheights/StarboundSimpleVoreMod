animState = "blank"
lock = true
temp = 0
--entity.setAnimationState("bodyState", "fed4")
--entity.playSound("digest")

eatLines = {
}

idleLines = {
}

bellyLines = {
}

function init()

end

function update(dt)
		
	animState = entity.animationState("bodyState")
	temp = math.random(500)
	
	if world.loungeableOccupied(entity.id()) then
		
		if animState == "default" then
			entity.setAnimationState("bodyState", "swallow")
		end
		
		
		
		if temp == 1 and animState == "full" then
			entity.setAnimationState("bodyState", "rub")
		elseif temp == 2 and animState == "full" then
			entity.setAnimationState("bodyState", "struggle")
		elseif temp == 3 and animState == "full" then
			entity.setAnimationState("bodyState", "fullblink")
		end
		
		
	else
		
		if animState == "full" then
			entity.setAnimationState("bodyState", "totail")
		end
		
		if temp == 1 and animState == "default" then
			entity.setAnimationState("bodyState", "blink")
		elseif temp == 2 and animState == "default" then
			entity.setAnimationState("bodyState", "smile")
		end
	end
end
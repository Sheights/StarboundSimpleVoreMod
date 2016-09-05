animState = "blank"
lock = true
temp = 0

eatLines = {	"Oh, what a unique taste.",
				"I normally only do this for Nicole, you know.",
				"*burp* Oh! Excuse me!"
}

idleLines = {	"Oh, someone new?",
				"Perhaps you would like to rest with me."
}

bellyLines = {	"Mmm... A wonderful feeling, is it not?",
				"'Tis relaxing, yes?",
				"Aah... To have a full stomach..."
}

function init()

end

function update(dt)
		
	animState = animator.animationState("bodyState")
	temp = math.random(500)
	
	if world.loungeableOccupied(entity.id()) then
		
		if animState == "default" then
			animator.setAnimationState("bodyState", "swallow")
			object.say( eatLines[ math.random(#eatLines) ] )
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
	
	if math.random(700) == 1 then
		if world.loungeableOccupied(entity.id()) then
			object.say( bellyLines[ math.random(#bellyLines) ] )
		else
			object.say( idleLines[ math.random(#idleLines) ] )
		end
	end
end
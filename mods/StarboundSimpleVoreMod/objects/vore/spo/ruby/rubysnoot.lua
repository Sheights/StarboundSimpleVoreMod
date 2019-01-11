animState = "blank"

gurgles = {	"belly1",
			"belly2",
			"belly3"
}

function init()

end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
	if animState == "empty" then
		-- play swallow sound
		animator.setAnimationState("bodyState", "swallow")
		animator.playSound("swallow")
	elseif animState == "full" and math.random(450) == 1 then
		animator.setAnimationState("bodyState", "burp")
		animator.playSound( gurgles[ math.random(3) ] )
	elseif animState == "full" and math.random(450) == 1 then
		-- play a gurgle
		animator.setAnimationState("bodyState", "struggle")
		animator.playSound( gurgles[ math.random(3) ] )
	elseif animState == "full" and math.random(450) == 1 then
		-- play a gurgle
		animator.setAnimationState("bodyState", "rub")
		animator.playSound( gurgles[ math.random(3) ] )
	elseif animState == "full" and math.random(600) == 1 then
		animator.setAnimationState("bodyState", "lay")
	elseif animState == "laying" and math.random(450) == 1 then
		animator.setAnimationState("bodyState", "lick")
	elseif animState == "laying" and math.random(450) == 1 then
		-- LET THAT BABY REV
		animator.setAnimationState("bodyState", "lexhaust")
		animator.playSound("rev")
	elseif animState == "laying" and math.random(450) == 1 then
		-- play a gurgle
		animator.setAnimationState("bodyState", "lstruggle")
		animator.playSound( gurgles[ math.random(3) ] )
	elseif animState == "laying" and math.random(600) == 1 then
		animator.setAnimationState("bodyState", "up")
	end
		
	else
		
		if animState == "empty" and math.random(450) == 1 then
			animator.setAnimationState("bodyState", "breath")
		elseif animState == "empty" and math.random(450) == 1 then
			animator.setAnimationState("bodyState", "yawn")
		elseif animState == "empty" and math.random(450) == 1 then
			-- LET THAT BABY REV
			animator.setAnimationState("bodyState", "exhaust")
			animator.playSound("rev")
		end
		
		if animState == "laying" then
			animator.setAnimationState("bodyState", "up")
		elseif animState == "full" then
			-- play a not swallow sound
			animator.setAnimationState("bodyState", "regurg")
			animator.playSound("spit")
		end
		
	end
end
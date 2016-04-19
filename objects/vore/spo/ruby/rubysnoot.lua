animState = "blank"

gurgles = {	"belly1",
			"belly2",
			"belly3"
}

function init()

end

function update(dt)

	animState = entity.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
	if animState == "empty" then
		-- play swallow sound
		entity.setAnimationState("bodyState", "swallow")
		entity.playSound("swallow")
	elseif animState == "full" and math.random(450) == 1 then
		entity.setAnimationState("bodyState", "burp")
		entity.playSound( gurgles[ math.random(3) ] )
	elseif animState == "full" and math.random(450) == 1 then
		-- play a gurgle
		entity.setAnimationState("bodyState", "struggle")
		entity.playSound( gurgles[ math.random(3) ] )
	elseif animState == "full" and math.random(450) == 1 then
		-- play a gurgle
		entity.setAnimationState("bodyState", "rub")
		entity.playSound( gurgles[ math.random(3) ] )
	elseif animState == "full" and math.random(600) == 1 then
		entity.setAnimationState("bodyState", "lay")
	elseif animState == "laying" and math.random(450) == 1 then
		entity.setAnimationState("bodyState", "lick")
	elseif animState == "laying" and math.random(450) == 1 then
		-- LET THAT BABY REV
		entity.setAnimationState("bodyState", "lexhaust")
		entity.playSound("rev")
	elseif animState == "laying" and math.random(450) == 1 then
		-- play a gurgle
		entity.setAnimationState("bodyState", "lstruggle")
		entity.playSound( gurgles[ math.random(3) ] )
	elseif animState == "laying" and math.random(600) == 1 then
		entity.setAnimationState("bodyState", "up")
	end
		
	else
		
		if animState == "empty" and math.random(450) == 1 then
			entity.setAnimationState("bodyState", "breath")
		elseif animState == "empty" and math.random(450) == 1 then
			entity.setAnimationState("bodyState", "yawn")
		elseif animState == "empty" and math.random(450) == 1 then
			-- LET THAT BABY REV
			entity.setAnimationState("bodyState", "exhaust")
			entity.playSound("rev")
		end
		
		if animState == "laying" then
			entity.setAnimationState("bodyState", "up")
		elseif animState == "full" then
			-- play a not swallow sound
			entity.setAnimationState("bodyState", "regurg")
			entity.playSound("spit")
		end
		
	end
end
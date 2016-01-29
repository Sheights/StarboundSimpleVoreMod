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
	
		if animState == "idle" then
			entity.setAnimationState("bodyState", "swallow")
			entity.playSound("swallow")
		elseif animState == "full" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "fullsnort")
		elseif animState == "full" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "squirm")
			entity.playSound( gurgles[ math.random(3) ] )
		elseif animState == "full" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "fullts")
		elseif animState == "full" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "indigestion")
			entity.playSound( gurgles[ math.random(3) ] )
		end

	else
	
		if animState == "idle" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "snort")
		elseif animState == "idle" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "tailswing")
		elseif animState == "idle" and math.random(700) == 1 then
			entity.setAnimationState("bodyState", "gurgle")
			entity.playSound( gurgles[ math.random(3) ] )
		end
		
		if animState == "full" then
			entity.setAnimationState("bodyState", "regurgitate")			
			entity.playSound("spit")
		end
		
	end
end
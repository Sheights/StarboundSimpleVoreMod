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
	
		if animState == "idle" then
			animator.setAnimationState("bodyState", "swallow")
			animator.playSound("swallow")
		elseif animState == "full" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "fullsnort")
		elseif animState == "full" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "squirm")
			animator.playSound( gurgles[ math.random(3) ] )
		elseif animState == "full" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "fullts")
		elseif animState == "full" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "indigestion")
			animator.playSound( gurgles[ math.random(3) ] )
		end

	else
	
		if animState == "idle" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "snort")
		elseif animState == "idle" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "tailswing")
		elseif animState == "idle" and math.random(700) == 1 then
			animator.setAnimationState("bodyState", "gurgle")
			animator.playSound( gurgles[ math.random(3) ] )
		end
		
		if animState == "full" then
			animator.setAnimationState("bodyState", "regurgitate")			
			animator.playSound("spit")
		end
		
	end
end
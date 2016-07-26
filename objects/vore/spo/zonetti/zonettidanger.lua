animState = "blank"

gurgles = {	"belly1",
			"belly2",
			"belly3"
}

digestState = 0
preyMaxHealth = 0
preyCurrentHealth = 0
preyPercentHealth = 0

prey = nil

function init()

end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if prey then
			preyCurrentHealth = world.entityHealth(prey)[1] * 100
			preyMaxHealth = world.entityHealth(prey)[2]
			preyPercentHealth = math.floor(preyCurrentHealth / preyMaxHealth)
			if preyPercentHealth < 10 then
				digestState = 1
			end
		end
	
		if animState == "idle" and digestState == 0 then
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
		
		if animState == "full" and digestState == 1 then
			animator.setAnimationState("bodyState", "digest")
			animator.playSound( gurgles[ math.random(3) ] )
		end

	else
	
		digestState = 0
		
		if animState == "full" then
			animator.setAnimationState("bodyState", "regurgitate")
		end
		
	end
	
	if animState == "idle" and math.random(500) == 1 then
		animator.setAnimationState("bodyState", "snort")
	elseif animState == "idle" and math.random(500) == 1 then
		animator.setAnimationState("bodyState", "tailswing")
	elseif animState == "idle" and math.random(700) == 1 then
		animator.setAnimationState("bodyState", "gurgle")
		animator.playSound( gurgles[ math.random(3) ] )
	end
	
end

function onInteraction(args)

  if not prey then
    prey = nil
  end

  -- Makes sure only the pred only checks the health of the prey inside.
  if world.loungeableOccupied(entity.id()) == false then
    prey = args.sourceId
  end

end
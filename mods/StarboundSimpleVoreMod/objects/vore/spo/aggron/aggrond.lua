animState = "blank"

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
	
		if animState == "idlecp" then
			animator.setAnimationState("bodyState", "swallow")
			animator.playSound("swallow")
		elseif animState == "fullcp" and math.random(200) == 1 then
			animator.setAnimationState("bodyState", "full")
			animator.playSound("gurgle1")
		elseif animState == "fullcp" and math.random(200) == 1 then
			animator.playsound("gurgle2")
		end

	else
	
		digestState = 0
	
		if animState == "idlecp" and math.random(100) == 1 then
			animator.setAnimationState("bodyState", "idle1")
			do return end
		elseif animState == "fullcp" then
			animator.setAnimationState("bodyState", "release")
			animator.playSound("cry")
			do return end
		end
		
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
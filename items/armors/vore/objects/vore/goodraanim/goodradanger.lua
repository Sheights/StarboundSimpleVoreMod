function init()
-- Animation related
  animLock = false
  soundLock = false
  releaseLock = false
  idleTimer = 0
  eatingTimer = 0
  releaseTimer = 0
-- Health related
  preyMaxHealth = 0
  preyCurrentHealth = 0
  preyPercentHealth = 0
  digestState = 0
end

function update(dt)
  -- Animations that happens while the predator is empty (hungry).
  if world.loungeableOccupied(entity.id()) == false then
	if digestState == 4 then
	  entity.setAnimationState("bodyState", "idle1")
	  eatingTimer = 0
	  animLock = true
	end
	
	-- Resets the digestState checker.
	digestState = 0
	  
	-- Resets the predator to the idle state
    if animLock == false then
	  entity.setAnimationState("bodyState", "idle1")
	  idleTimer = 0
      releaseLock = false
      releaseTimer = 0
	    -- If player leaves after being eaten, it plays the release animation.
		if eatingTimer >= 20 then
		  animLock = true
		  eatingTimer = 0
		  releaseLock = true
		  entity.setAnimationState("bodyState", "release")
		  entity.playSound("lay")
		end
	  end
	-- Randomises different animations, like idle2, blink and waiting.
	if animLock == false and math.random(200) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "idle2")
	end
	  
	  	if animLock == false and math.random(200) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "idle3")
	end
	  
	if animLock == false and math.random(100) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "blink")
	end
	  
	if idleTimer >= 28 or releaseTimer >= 9 then
	  animLock = false
	end 
	  
	-- Counts time being idle and empty.
	idleTimer = idleTimer + 1
	  
	if releaseLock == true then
	  releaseTimer = releaseTimer + 1
	end
  elseif world.loungeableOccupied(entity.id()) == true and eatingTimer <= 20 then
    -- Swallow animation
	if soundLock == false then
	  entity.playSound("swallow")
      soundLock = true
	end
	  
	entity.setAnimationState("bodyState", "swallow")
	eatingTimer = eatingTimer + 1
	  
  else
    -- Animations that happens while the predator is full (digesting).
	
    -- Math to find player percent health
	preyCurrentHealth = world.entityHealth(prey)[1] * 100
	preyMaxHealth = world.entityHealth(prey)[2]
	preyPercentHealth = math.floor(preyCurrentHealth / preyMaxHealth)
	
	soundLock = false
	-- Changes player state based on their current percent health
	if preyPercentHealth <= 100 and digestState == 0 then
	  entity.setAnimationState("bodyState", "fullbig")
	  digestState = digestState + 1
	elseif preyPercentHealth <= 55 and digestState == 1 then
	  entity.setAnimationState("bodyState", "bigtosmall")
      digestState = digestState + 1
	elseif preyPercentHealth <= 25 and digestState == 2 then
	  entity.setAnimationState("bodyState", "smalltomicro")
	  digestState = digestState + 1
	elseif preyPercentHealth <= 3 and digestState == 3 then
	  entity.setAnimationState("bodyState", "microtonone")
	  digestState = digestState + 1
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
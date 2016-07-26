function init()
-- Animation related
  animLock = false
  soundLock = false
  releaseLock = false
  idleTimer = 0
  eatingTimer = 0
  releaseTimer = 0
end

function update(dt)
  -- Animations that happens while the predator is empty (hungry).
  if world.loungeableOccupied(entity.id()) == false then
	  
	-- Resets the predator to the idle state
    if animLock == false then
	  animator.setAnimationState("bodyState", "waiting")
	  idleTimer = 0
      releaseLock = false
      releaseTimer = 0
	    -- If player leaves after being eaten, it plays the release animation.
		if eatingTimer >= 20 then
		  animLock = true
		  eatingTimer = 0
		  releaseLock = true
		  animator.setAnimationState("bodyState", "release")
		  animator.playSound("lay")
		end
	  end
	-- Randomises different animations, like idle2, blink and waiting.
	if animLock == false and math.random(200) == 1 then
	  animLock = true
	  animator.setAnimationState("bodyState", "idle1")
	end
	  
	if animLock == false and math.random(200) == 1 then
	animLock = true
	  animator.setAnimationState("bodyState", "idle2")
	end
	  
	if animLock == false and math.random(100) == 1 then
	  animator.setAnimationState("bodyState", "blink")
	end
	  
	if idleTimer >= 30 or releaseTimer >= 9 then
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
	  animator.playSound("swallow")
      soundLock = true
	end
	  
	animator.setAnimationState("bodyState", "swallow")
	eatingTimer = eatingTimer + 1
	  
  else
    -- Animations that happens while the predator is full (digesting).
	
	soundLock = false
	animator.setAnimationState("bodyState", "fullbig")
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
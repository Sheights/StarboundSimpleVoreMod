function init()
  idleTimer = 0
  eatingTimer = 0
  animLock = 0
  blinkLock = 0
  blinkTimer = 0
end

function update(dt)
	if world.loungeableOccupied(entity.id()) == false then

      if animLock == 0 then
	    animator.setAnimationState("pred", "idle")
	    blinkLock = 0
		blinkTimer = 0
		idleTimer = 0
		if eatingTimer >= 10 then
		  animator.playSound("spit")
		  animLock = 1
		  eatingTimer = 0
		  animator.setAnimationState("pred", "pain")
		end
	  end
	  
	  if animLock == 0 and math.random(100) == 1 then
		animLock = 1
		blinkLock = 1
	    animator.setAnimationState("pred", "blink")
	  end
	  
	  if idleTimer >= 7 or blinkTimer >=3 then
	    animLock = 0
	  end
	  
	  idleTimer = idleTimer + 1
	  
	elseif world.loungeableOccupied(entity.id()) == true and eatingTimer <= 10 then
	  if eatingTimer == 4 then
	    animator.playSound("swallow")
	  end
	  animator.setAnimationState("pred", "eating")
	  eatingTimer = eatingTimer + 1
	
	elseif eatingTimer > 10 and math.random(75) == 1 then
		animator.setAnimationState("pred", "sigh")
		blinkLock = 1
		
	elseif blinkTimer == 0 or blinkTimer > 10 then
	  animator.setAnimationState("pred", "fed")
	  blinkLock = 0
	  blinkTimer = 0
	end
	
	if blinkLock == 1 then
		blinkTimer = blinkTimer + 1
	end
end
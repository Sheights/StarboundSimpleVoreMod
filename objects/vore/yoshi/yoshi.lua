function init()
  idleTimer = 0
  eatingTimer = 0
  eggLock = 0
  eggTimer = 0
  animLock = 0
  blinkLock = 0
  blinkTimer = 0
end

function update(dt)
	if world.loungeableOccupied(entity.id()) == false then

      if animLock == 0 then
	    entity.setAnimationState("bodyState", "idle1")
	    blinkLock = 0
		blinkTimer = 0
		idleTimer = 0
		eggLock = 0
		eggTimer = 0
		if eatingTimer >= 20 then
		  animLock = 1
		  eatingTimer = 0
		  eggLock = 1
		  entity.setAnimationState("bodyState", "egglay")
		  entity.playSound("lay")
		  
		end
	  end
	  
	  if animLock == 0 and math.random(200) == 1 then
	    animLock = 1
	    entity.setAnimationState("bodyState", "idle2")
	  end
	  
	  if animLock == 0 and math.random(200) == 1 then
	    animLock = 1
		entity.setAnimationState("bodyState", "idle3")
	  end
	  
	  if animLock == 0 and math.random(100) == 1 then
		animLock = 1
		blinkLock = 1
	    entity.setAnimationState("bodyState", "blink")
	  end
	  
	  if idleTimer >= 30 or eggTimer >= 9 or blinkTimer >=3 then
	    animLock = 0
	  end
	  
	  idleTimer = idleTimer + 1
	  
	  if blinkLock == 1 then
		blinkTimer = blinkTimer + 1
	  end
	  
	  if eggLock == 1 then
	    eggTimer = eggTimer + 1
	  end
	  
	elseif world.loungeableOccupied(entity.id()) == true and eatingTimer <= 20 then
	  if eatingTimer == 8 then
	    entity.playSound("swallow")
	  end
	  entity.setAnimationState("bodyState", "eating")
	  eatingTimer = eatingTimer + 1
	
	else
	  entity.setAnimationState("bodyState", "fed")
	end
end
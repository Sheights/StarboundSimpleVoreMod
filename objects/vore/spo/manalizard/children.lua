function init()
  idleTimer = 0
  eatingTimer = 0
  animLock = 0
  blinkLock = 0
  blinkTimer = 0
  sleepLock = 0
  
  self.detectArea = entity.configParameter("detectArea")
  self.detectArea[1] = entity.toAbsolutePosition(self.detectArea[1])
  self.detectArea[2] = entity.toAbsolutePosition(self.detectArea[2])
  
end

function update(dt)
	if world.loungeableOccupied(entity.id()) == false then

	  local people = world.entityQuery(self.detectArea[1], self.detectArea[2], {
        includedTypes = {"npc", "player"},
        boundMode = "CollisionArea"
      })
	  
	  if sleepLock == 1 and #people == 0 then
	    do return end
	  else
	    sleepLock = 0
	  end
	  
      if animLock == 0 then
	    entity.setAnimationState("pred", "idle")
	    blinkLock = 0
		blinkTimer = 0
		idleTimer = 0
		if eatingTimer >= 10 then
		  entity.playSound("spit")
		  animLock = 1
		  eatingTimer = 0
		  entity.setAnimationState("pred", "pain")
		end
	  end
	  
	  if animLock == 0 and math.random(100) == 1 then
		animLock = 1
		blinkLock = 1
	    entity.setAnimationState("pred", "blink")
	  end
	  
	  if idleTimer >= 7 or blinkTimer >=3 then
	    animLock = 0
	  end
	  
	  idleTimer = idleTimer + 1
	  
	  if #people == 0 and math.random(1000) == 1 then
		entity.setAnimationState("pred", "sleep")
		sleepLock = 1
		animLock = 1
	  end
	  
	elseif world.loungeableOccupied(entity.id()) == true and eatingTimer <= 10 then
	  if eatingTimer == 4 then
	    entity.playSound("swallow")
	  end
	  entity.setAnimationState("pred", "eating")
	  eatingTimer = eatingTimer + 1
	
	elseif eatingTimer > 10 and math.random(100) == 1 then
		entity.setAnimationState("pred", "sigh")
		blinkLock = 1
		
	elseif eatingTimer > 10 and math.random(50) == 1 then
		entity.setAnimationState("pred", "fedblink")
		blinkLock = 1
		
	elseif blinkTimer == 0 or blinkTimer > 10 then
	  entity.setAnimationState("pred", "fed")
	  blinkLock = 0
	  blinkTimer = 0
	end
	
	if blinkLock == 1 then
		blinkTimer = blinkTimer + 1
	end
end
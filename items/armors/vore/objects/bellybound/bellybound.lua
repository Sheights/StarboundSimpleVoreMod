ohSnap = false
animLock = false
blinkLock = false
blinkTimer = 0
fadeLock = false
fadeTimer = 0
greetLock = false
greetTimer = 0
lookLock = false
lookTimer = 0
signLock = false
signTimer = 0
tailLock = false
tailTimer = 0
waveLock = false
waveTimer = 0

function init(virtual)
  if not virtual then
    self.detectArea = entity.configParameter("detectArea")
    self.detectArea[1] = entity.toAbsolutePosition(self.detectArea[1])
    self.detectArea[2] = entity.toAbsolutePosition(self.detectArea[2])
  end
end

function update(dt)
	-- Vore Chat Handler
	local players = world.entityQuery(self.detectArea[1], self.detectArea[2], {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
	})
	local chatIdle = entity.configParameter("chatIdle", {})
	
	if #players > 0 and not ohSnap then
	entity.say(chatIdle[math.random(1, #chatIdle)])
	  ohSnap = true
	elseif #players == 0 and ohSnap then
	  ohSnap = false
    end
	
	-- Animation Handler
    if animLock == false then
	  entity.setAnimationState("bodyState", "idle")
	  blinkTimer = 0
	  fadeTimer = 0
	  greetTimer = 0
	  lookTimer = 0
	  signTimer = 0
	  tailTimer = 0
	  waveTimer = 0
	end
	  
	if animLock == false and math.random(200) == 1 then
	  animLock = 1
	  entity.setAnimationState("bodyState", "blink")
	end
	  
	if animLock == false and math.random(400) == 1 then
	  animLock = 1
      entity.setAnimationState("bodyState", "fade")
	end
	  
	if animLock == false and math.random(400) == 1 then
	  animLock = 1
	  entity.setAnimationState("bodyState", "greet")
	end
	
	if animLock == false and math.random(400) == 1 then
	  animLock = 1
	  entity.setAnimationState("bodyState", "look")
	end
	
	if animLock == false and math.random(400) == 1 then
	  animLock = 1
	  entity.setAnimationState("bodyState", "sign")
	end
	
	if animLock == false and math.random(400) == 1 then
	  animLock = 1
	  entity.setAnimationState("bodyState", "tail")
	end
	
	if animLock == false and math.random(400) == 1 then
	  animLock = 1
	  entity.setAnimationState("bodyState", "wave")
	end
	  
	if blinkTimer >= 50 or fadeTimer >= 50 or greetTimer >= 50 or lookTimer >= 50 or signTimer >= 50 or tailTimer >= 50 or waveTimer >= 50 then
	  animLock = false
	end
	  
	blinkTimer = blinkTimer + 1
	fadeTimer = fadeTimer + 1
	greetTimer = greetTimer + 1
	lookTimer = lookTimer + 1
	signTimer = signTimer + 1
	tailTimer = tailTimer + 1
	waveTimer = waveTimer + 1
	
end
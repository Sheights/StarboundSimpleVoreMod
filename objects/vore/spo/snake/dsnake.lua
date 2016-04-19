animState = "blank"

beat = 0.3
health = 1
timer = 0
swallowTimer = 0

eatLock = true
swallowLock = true

function init()

end

function update(dt)
	
	if world.loungeableOccupied(entity.id()) then
	
		if victim ~= null then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
		
		animState = entity.animationState("bodyState")
		
		timer = timer + dt
	
		if health < 0.2 and timer > 15 then
--			fed4

			entity.setAnimationState("bodyState", "fed4")
			beat = beat + dt
			if beat >=0.8 then
				entity.playSound("digest")
				beat = beat - 0.8
			end
			
		elseif health < 0.35 and timer > 12.6 then
--			fed3

			entity.setAnimationState("bodyState", "fed3")
			beat = beat + dt
			if beat >=0.8 then
				entity.playSound("digest")
				beat = beat - 0.8
			end
			
		elseif health < 0.5 and timer > 10.2 then
--			fed2

			entity.setAnimationState("bodyState", "fed2")
			beat = beat + dt
			if beat >=0.8 then
				entity.playSound("digest")
				beat = beat - 0.8
			end
			
		elseif health < 0.65 and animState == "fed1" then
--			fed1
		
			beat = beat + dt
			if beat >=0.8 then
				entity.playSound("digest")
				beat = beat - 0.8
			end
			
		elseif health < 0.65 and timer > 4.8  then
--			swallow

			entity.setAnimationState("bodyState", "swallow")
			
			swallowTimer = swallowTimer + dt
			
			if eatLock and swallowTimer > 1 then
				entity.playSound("eat")
				eatLock = false
			elseif swallowLock and swallowTimer > 0.5 then
				entity.playSound("swallow")
				swallowLock = false
			end
		
		elseif health < 0.80 and timer > 3 then
--			coil2

			entity.setAnimationState("bodyState", "coil2")
			beat = beat + dt
			if beat >=0.4 then
				entity.playSound("coil")
				beat = beat - 0.4
			end
		else
--			coil1

			entity.setAnimationState("bodyState", "coil1")
			beat = beat + dt
			if beat >=0.6 then
				entity.playSound("coil")
				beat = beat - 0.6
			end
		end		
	else
		beat = 0.3
		swallowTimer = 0
		timer = 0
		eatLock = true
		swallowLock = true
		animState = entity.animationState("bodyState")
		
		if animState == "fed1" or animState == "fed2" or animState == "fed3" or animState == "fed4" then
			entity.setAnimationState("bodyState", "release")
			entity.playSound("eat")
		elseif animState == "coil1" or animState == "coil2" or animState == "swallow" then
			entity.setAnimationState("bodyState", "idle1")
		elseif animState == "idle1" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "idle2")
		end
	end
end

function onInteraction(args)
	victim = args.sourceId
end
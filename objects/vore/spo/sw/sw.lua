animState = "blank"

victim = nil
health = nil

soundlock = false
soundtimer = 0

--entity.setAnimationState("bodyState", "fed4")
--entity.playSound("digest")
function init()

end

function update(dt)
		
	animState = entity.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if victim ~= nil then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
		
		if animState == "standing" or animState == "idle" then
			entity.setAnimationState("bodyState", "eat")
			entity.playSound("nom")
		end
		
		if health == nil then
			health = 1
		end
		
		if health < 0.8 and animState == "midle" then
			entity.setAnimationState("bodyState", "gulp")
		elseif health < 0.3 and animState == "stomachidle" then
			entity.setAnimationState("bodyState", "transfer")
			entity.playSound("stomachtransfer")
		end
		
		if math.random(100) == 1 then
			if animState == "midle" then
				if math.random(2) == 1 then
					entity.setAnimationState("bodyState", "msd")
					entity.playSound("mouthstruggle1")
				else
					entity.setAnimationState("bodyState", "msu")
					entity.playSound("mouthstruggle2")
				end
			elseif animState == "stomachidle" then
				if math.random(5) == 1 then
					entity.setAnimationState("bodyState", "sdr")
					entity.playSound("stomachstruggle1")
				elseif math.random(4) == 1 then
					entity.setAnimationState("bodyState", "sul")
					entity.playSound("stomachstruggle2")
				elseif math.random(3) == 1 then
					entity.setAnimationState("bodyState", "sur")
					entity.playSound("stomachstruggle3")
				elseif math.random(2) == 1 then
					entity.setAnimationState("bodyState", "sdl")
					entity.playSound("stomachstruggle3")
				else
					entity.setAnimationState("bodyState", "sr")
					entity.playSound("stomachstruggle2")
				end
			end
		end
		
		if animState == "gulp" then
			if soundlock and soundtimer > ( 9 / 11 * 1.3 ) then
				soundlock = false
				entity.playSound("gulp")
			end
			soundtimer = soundtimer + dt
		end
		
	else
		
		soundtimer = 0
		soundlock = true
		
		if animState == "sidle" then
			entity.setAnimationState("bodyState", "wake")
		end
		
		if animState == "midle" or animState == "stomachidle" then
			entity.setAnimationState("bodyState", "standing")
		end
		
		if animState == "standing" and math.random(350) == 1 then	
			entity.setAnimationState("bodyState", "standtoidle")
			entity.playSound("krrr")
		elseif animState == "idle" and math.random(200) == 1 then
			entity.setAnimationState("bodyState", "hiss")
			entity.playSound("hiss")
		elseif animState == "idle" and math.random(450) == 1 then
			entity.setAnimationState("bodyState", "idletostand")
		end
			
	end
	
end

function onInteraction(args)

	victim = args.sourceId
	
end
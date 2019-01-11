animState = "blank"

victim = nil
health = nil

soundlock = false
soundtimer = 0

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")
function init()

end

function update(dt)
		
	animState = animator.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if victim ~= nil then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
		
		if animState == "standing" or animState == "idle" then
			animator.setAnimationState("bodyState", "eat")
			animator.playSound("nom")
		end
		
		if health == nil then
			health = 1
		end
		
		if health < 0.8 and animState == "midle" then
			animator.setAnimationState("bodyState", "gulp")
		elseif health < 0.3 and animState == "stomachidle" then
			animator.setAnimationState("bodyState", "transfer")
			animator.playSound("stomachtransfer")
		end
		
		if math.random(100) == 1 then
			if animState == "midle" then
				if math.random(2) == 1 then
					animator.setAnimationState("bodyState", "msd")
					animator.playSound("mouthstruggle1")
				else
					animator.setAnimationState("bodyState", "msu")
					animator.playSound("mouthstruggle2")
				end
			elseif animState == "stomachidle" then
				if math.random(5) == 1 then
					animator.setAnimationState("bodyState", "sdr")
					animator.playSound("stomachstruggle1")
				elseif math.random(4) == 1 then
					animator.setAnimationState("bodyState", "sul")
					animator.playSound("stomachstruggle2")
				elseif math.random(3) == 1 then
					animator.setAnimationState("bodyState", "sur")
					animator.playSound("stomachstruggle3")
				elseif math.random(2) == 1 then
					animator.setAnimationState("bodyState", "sdl")
					animator.playSound("stomachstruggle3")
				else
					animator.setAnimationState("bodyState", "sr")
					animator.playSound("stomachstruggle2")
				end
			end
		end
		
		if animState == "gulp" then
			if soundlock and soundtimer > ( 9 / 11 * 1.3 ) then
				soundlock = false
				animator.playSound("gulp")
			end
			soundtimer = soundtimer + dt
		end
		
	else
		
		soundtimer = 0
		soundlock = true
		
		if animState == "sidle" then
			animator.setAnimationState("bodyState", "wake")
		end
		
		if animState == "midle" or animState == "stomachidle" then
			animator.setAnimationState("bodyState", "standing")
		end
		
		if animState == "standing" and math.random(350) == 1 then	
			animator.setAnimationState("bodyState", "standtoidle")
			animator.playSound("krrr")
		elseif animState == "idle" and math.random(200) == 1 then
			animator.setAnimationState("bodyState", "hiss")
			animator.playSound("hiss")
		elseif animState == "idle" and math.random(450) == 1 then
			animator.setAnimationState("bodyState", "idletostand")
		end
			
	end
	
end

function onInteraction(args)

	victim = args.sourceId
	
end
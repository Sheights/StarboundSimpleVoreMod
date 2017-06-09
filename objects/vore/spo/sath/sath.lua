animState = "blank"

function init()

end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idlecp" then
			animator.setAnimationState("bodyState", "swallow")
			animator.playSound("swallow")
		elseif animState == "fullcp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "fidle1")
		elseif animState == "fullcp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "fidle2")
		elseif animState == "fullcp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "flay")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "flidle1")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "flidle2")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "flidle3")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "fup")
		elseif animState == "sleep" then
			animator.setAnimationState("bodyState", "up")
		end

	else
	
		if animState == "idlecp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "idle1")
			do return end
		elseif animState == "idlecp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "idle2")
			do return end
		elseif animState == "idlecp" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "idle3")
			do return end
		elseif animState == "sleep" and math.random(800) == 1 then
			animator.setAnimationState("bodyState", "up")
			do return end
		elseif animState == "fullcp" then
			animator.setAnimationState("bodyState", "spit")
			do return end
		elseif animState == "fulllaycp" then
			animator.setAnimationState("bodyState", "fup")
			do return end
		end
		
		if math.random(600) == 1 then
			local people = world.entityQuery( object.position(), 10, {
				includedTypes = {"npc", "player"},
				boundMode = "CollisionArea"
			})
			if #people == 0 and animState == "idlecp" then
				animator.setAnimationState("bodyState", "lay")
			elseif #people > 0 and animState == "sleep" then
				animator.setAnimationState("bodyState", "up")
			end
		end
	end
end
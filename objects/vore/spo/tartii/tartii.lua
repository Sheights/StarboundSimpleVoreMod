animState = "blank"

function init()

end

function update(dt)

	animState = entity.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idlecp" then
			entity.setAnimationState("bodyState", "swallow")
			entity.playSound("swallow")
		elseif animState == "fullcp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "fidle1")
		elseif animState == "fullcp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "fidle2")
		elseif animState == "fullcp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "fidle3")
		elseif animState == "fullcp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "flay")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "flidle1")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "flidle2")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "flidle3")
		elseif animState == "fulllaycp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "fup")
		elseif animState == "sleep" then
			entity.setAnimationState("bodyState", "up")
		end

	else
	
		if animState == "idlecp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "idle1")
			do return end
		elseif animState == "idlecp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "idle2")
			do return end
		elseif animState == "idlecp" and math.random(500) == 1 then
			entity.setAnimationState("bodyState", "idle3")
			do return end
		elseif animState == "sleep" and math.random(800) == 1 then
			entity.setAnimationState("bodyState", "up")
			do return end
		elseif animState == "fullcp" then
			entity.setAnimationState("bodyState", "spit")
			do return end
		elseif animState == "fulllaycp" then
			entity.setAnimationState("bodyState", "fup")
			do return end
		end
		
		if math.random(600) == 1 then
			local people = world.entityQuery( entity.position(), 10, {
				includedTypes = {"npc", "player"},
				boundMode = "CollisionArea"
			})
			if #people == 0 and animState == "idlecp" then
				entity.setAnimationState("bodyState", "lay")
			elseif #people > 0 and animState == "sleep" then
				entity.setAnimationState("bodyState", "up")
			end
		end
	end
end
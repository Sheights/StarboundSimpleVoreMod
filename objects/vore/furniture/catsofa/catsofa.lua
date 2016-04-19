
function update(dt)

	-- Animation Handler
	state = entity.animationState("bodyState")

	if state == "idle"  and world.loungeableOccupied(entity.id()) == false then
		if math.random(200) == 1 then
			temp = math.random(6)
			if temp == 1 then
				entity.setAnimationState("bodyState", "tail")
			elseif temp == 2 then
				entity.setAnimationState("bodyState", "struggle")
			elseif temp == 3 then
				entity.setAnimationState("bodyState", "rub")
			elseif temp == 4 then
				entity.setAnimationState("bodyState", "push")
			elseif temp == 5 then
				entity.setAnimationState("bodyState", "pat")
			else
				entity.setAnimationState("bodyState", "lick")
			end
		end
	end
end

function onInteraction(args)

	entity.setAnimationState("bodyState", "idle")
	
end
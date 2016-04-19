temp = 0

function init()
  self.buyFactor = entity.configParameter("buyFactor", root.assetJson("/merchant.config").defaultBuyFactor)

  entity.setInteractive(true)
end

function update(dt)

	state = entity.animationState("bodyState")

	if state == "closed" or state == "peek" then
		local people = world.entityQuery( entity.position(), 20, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
		if #people > 0 then
			if math.random(2) == 1 then
				entity.setAnimationState("bodyState", "up")
			else
				entity.setAnimationState("bodyState", "upfull")
			end
			do return end
		else
			if math.random(3) == 1 then
				if state == "closed" then
					entity.setAnimationState("bodyState", "peek")
				else
					entity.setAnimationState("bodyState", "closed")
				end
			end
		end
	elseif math.random(2) == 1 then
		if state == "idle" then
			local people = world.entityQuery( entity.position(), 20, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people == 0 then
				entity.setAnimationState("bodyState", "down")
				do return end
			end
			temp = math.random(4)
			if temp == 1 then
				entity.setAnimationState("bodyState", "blink")
			elseif temp == 2 then
				entity.setAnimationState("bodyState", "tail")
			elseif temp == 3 then
				entity.setAnimationState("bodyState", "maruup")
			else
				entity.setAnimationState("bodyState", "smile")
			end
		elseif state == "full" then
			local people = world.entityQuery( entity.position(), 20, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people == 0 then
				entity.setAnimationState("bodyState", "downfull")
				do return end
			end
			temp = math.random(4)
			if temp == 1 then
				entity.setAnimationState("bodyState", "blinkfull")
			elseif temp == 2 then
				entity.setAnimationState("bodyState", "rub")
			elseif temp == 3 then
				entity.setAnimationState("bodyState", "tailfull")
			else
				entity.setAnimationState("bodyState", "smilefull")
			end
		elseif state == "maru" then
			if math.random(2) == 1 then
				entity.setAnimationState("bodyState", "marudown")
			else
				entity.setAnimationState("bodyState", "teaup")
			end
		elseif state == "tea" then
			entity.setAnimationState("bodyState", "teadown")
		end
	end
end

function init(virtual)
  if not virtual then
    self.detectArea = entity.configParameter("detectArea")
    self.detectArea[1] = entity.toAbsolutePosition(self.detectArea[1])
    self.detectArea[2] = entity.toAbsolutePosition(self.detectArea[2])
  end
end

function update(dt)
	-- Vore Chat Handler
	local players = world.entityQuery(entity.position(), 6, {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
	})
	-- Animation Handler
	state = entity.animationState("bodyState")
	
    -- entity.setAnimationState("bodyState", "blink")
	-- entity.animationState
	
	if #players == 0 and state == "idle" then
		entity.setAnimationState("bodyState", "shutdown")
	end
	
	if #players > 0 and state == "off" then
		entity.setAnimationState("bodyState", "startup")
	end
	
	if math.random(200) == 1 and state == "idle" then
		entity.setAnimationState("bodyState", "open")
	end
	
	if state == "turn" then
		local storeFront = world.entityQuery( entity.position(), 3, {
		includedTypes = {"player"},
		boundMode = "CollisionArea"
		})
		if #storeFront == 0 then
			entity.setAnimationState("bodyState", "turnback")
		end
	end
end

function onInteraction(args)

	local interactData = entity.configParameter("interactData")
	
	entity.setAnimationState("bodyState", "turn")
	
	return { "OpenCraftingInterface", interactData }
	
end
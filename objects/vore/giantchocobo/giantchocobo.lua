fed = false
initialized = false
voreActive = true

animState = ""

swallowTimer = 0
timer = 0

function init()

	if world.getProperty("invinciblePlayers") == true then
		voreActive = false
	end
	
	entity.setInteractive(true)
	
end

function update(dt)

	animState = entity.animationState("bodyState")
	if fed then
		---The estimated time the player is realeased
		if timer >=90 then

			---If the player was projected to die

			---Set states and reset variables
			entity.setAnimationState("bodyState", "spitup")
			entity.setInteractive(true)
			entity.playSound("close")

			fed = false
			swallowTimer = 0
			timer = 0
			
			do return end

		end
		
		---While the player is eaten
		timer = timer + dt
		
		if animState == "idle3" and math.random(600) == 1 then
			entity.setAnimationState("bodyState", "fed")
			do return end
		end
		
		if swallowTimer < 7 then
			swallowTimer = swallowTimer + 1
		elseif swallowTimer == 7 then
			entity.playSound("swallow")
			swallowTimer = swallowTimer + 1
		end

	elseif animState == "idle1" and math.random(600) == 1 then
		entity.setAnimationState("bodyState", "idle2")
		do return end
	end
	
	local people = world.entityQuery( entity.position(), 4, {
		includedTypes = {"player"},
		boundMode = "CollisionArea"
	})
			
	if animState == "idle1" and #people == 1 then
		entity.setAnimationState("bodyState", "open")
		-- play open sound
		entity.playSound("open")
	elseif animState == "fullOpen" and #people == 0 then
		entity.setAnimationState("bodyState", "close")
		-- play close sound
		entity.playSound("close")
	end
end

function onInteraction()

	if initialized == true and fed == false then
		if math.random() >= 0.97 then
			---get the player		
			local people = world.entityQuery( entity.position(), 7, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people == 1 then
				victim = people[1]
			else
				do return end
			end
		
			---spawn projectile
			temp = entity.id()
			
			local mergeOptions = {
				statusEffects = {
				{
					effect = "objectvore",
					duration = temp
			}}}
			world.spawnProjectile( "objectvoreprojectile" , world.entityPosition( victim ), entity.id(), {0, 0}, false, mergeOptions)
			entity.playSound("eat")
		
			---change states
			world.containerClose( entity.id() )
			entity.setAnimationState("bodyState", "eat")
			entity.setInteractive(false)
			fed = true
		
			---check if the encounter will be fatal
		end
	end
	initialized = true

end
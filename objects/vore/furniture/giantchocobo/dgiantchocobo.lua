fatal = false																				---
fed = false
initialized = false
isDigest = true
voreActive = true

animState = ""

swallowTimer = 0
timer = 0

function init()

	if world.getProperty("invinciblePlayers") == true then
		voreActive = false
	end
	
	object.setInteractive(true)
	
end

function update(dt)

	animState = animator.animationState("bodyState")
	if fed then
		---The estimated time the player is realeased
		if timer >=90 then

			---If the player was projected to die
			if fatal then
				world.containerAddItems( entity.id(), { name= "bone", count= 5, data={}} )
			end

			---Set states and reset variables
			animator.setAnimationState("bodyState", "spitup")
			object.setInteractive(true)
			animator.playSound("close")

			fatal = false
			fed = false
			swallowTimer = 0
			timer = 0
			
			do return end

		end
		
		---While the player is eaten
		timer = timer + dt
		
		if animState == "idle3" and math.random(600) == 1 then
			animator.setAnimationState("bodyState", "fed")
			do return end
		end
		
		if swallowTimer < 7 then
			swallowTimer = swallowTimer + 1
		elseif swallowTimer == 7 then
			animator.playSound("swallow")
			swallowTimer = swallowTimer + 1
		end

	elseif animState == "idle1" and math.random(600) == 1 then
		animator.setAnimationState("bodyState", "idle2")
		do return end
	end
	
	local people = world.entityQuery( object.position(), 4, {
		includedTypes = {"player"},
		boundMode = "CollisionArea"
	})
			
	if animState == "idle1" and #people == 1 then
		animator.setAnimationState("bodyState", "open")
		-- play open sound
		animator.playSound("open")
	elseif animState == "fullOpen" and #people == 0 then
		animator.setAnimationState("bodyState", "close")
		-- play close sound
		animator.playSound("close")
	end
end

function onInteraction()

	if initialized == true and fed == false then
		if math.random() >= 0.97 then
			---get the player		
			local people = world.entityQuery( object.position(), 7, {
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
			
			if isDigest then
				temp = temp + 10000
			end
			
			local mergeOptions = {
				statusEffects = {
				{
					effect = "objectvore",
					duration = temp
			}}}
			world.spawnProjectile( "objectvoreprojectile" , world.entityPosition( victim ), entity.id(), {0, 0}, false, mergeOptions)
			animator.playSound("eat")
		
			---change states
			world.containerClose( entity.id() )
			animator.setAnimationState("bodyState", "eat")
			object.setInteractive(false)
			fed = true
		
			---check if the encounter will be fatal
			local preCur = world.entityHealth(victim)[1]
			local preMax = world.entityHealth(victim)[2]
			if preCur / preMax < 0.6 then
				fatal = true
			end
		end
	end
	initialized = true

end
require "/scripts/vore/npcvore.lua"

duration = 90
audio = false

-- Set this to determine how long each stage of "compression" will last.  The lower the value, the faster she compresses you.
-- Default is 30.  Don't go any lower than 2 or you might have problems actually escaping.  Or it'll break.  Either way, not good.
stageInterval = 30

-- Fluff-wise, she tends to only UB people that want it.  So player vore should be request only, usually.
-- Besides, she only does her thing with request vore, so yah.  :P
playerChance = 0
npcChance = 0.01


playerLines = {	"^red;<3",
				"^white;O^pink;#^white;v^pink;#^white;O",
				"-v- ~ ^red;<3",
				"^red;<3 <3 <3",
				"^red;<3 ^pink;<3 ^red;<3",
				"^red;*love*",
				"^red;*warmth*",
				"^red;*pleasure*",
				"^red;*happiness*",
				"^red;*bliss*"
}

function initHook()

	if storage.belly == nil then
		storage.belly = ""
	end
	
end

function feedHook()

	entity.setItemSlot( "head", "argonpcheadbelly1" )
	entity.setItemSlot( "chest", "argonpcchestbelly1" )
	entity.setItemSlot( "legs", "argonpcpantsbelly1" )

	storage.belly = "1"

end

function loseHook()
	
--	if isPlayer then
--		entity.say("^blue;<3")
--	end
	
	entity.setItemSlot( "head", "argonpchead" )
	entity.setItemSlot( "chest", "argonpcchest" )
	entity.setItemSlot( "legs", "argonpcpants" )
	
	storage.belly = ""
	
	isPlayer = false
	
end

function interact(args)
	
	if talkTimer < 1 then
	
		if fed then
			if request then
				if stopWatch <= stageInterval then
					world.spawnProjectile( "cleanser" , mcontroller.position(), entity.id(), {0, 0}, true )
					stopWatch = duration
					digest()
					entity.say("^blue;<3")
				else
					stopWatch = stopWatch - stageInterval
					talkTimer = 1
				end
			else
				world.spawnProjectile( "cleanser" , mcontroller.position(), entity.id(), {0, 0}, true )
				stopWatch = duration
				digest()
			end
		else
			request = true
			feed()
		end
		
	else
		talkTimer = 0
	end

	interactHook()
	oldInteract(args)

	return nil

end

function updateHook()


	
	if request then
		if stopWatch > stageInterval*5 then
			entity.setItemSlot( "head", "argonpcheadbelly5" )
			entity.setItemSlot( "chest", "argonpcchest" )
			entity.setItemSlot( "legs", "argonpcpants" )
			storage.belly = "5"
		elseif stopWatch > stageInterval*4 then
			entity.setItemSlot( "head", "argonpcheadbelly5" )
			entity.setItemSlot( "chest", "argonpcchestbelly5" )
			entity.setItemSlot( "legs", "argonpcpantsbelly5" )
			storage.belly = "5"
		elseif stopWatch > stageInterval*3 then
			entity.setItemSlot( "head", "argonpcheadbelly4" )
			entity.setItemSlot( "chest", "argonpcchestbelly4" )
			entity.setItemSlot( "legs", "argonpcpantsbelly4" )
			storage.belly = "4"
		elseif stopWatch > stageInterval*2 then
			entity.setItemSlot( "head", "argonpcheadbelly3" )
			entity.setItemSlot( "chest", "argonpcchestbelly3" )
			entity.setItemSlot( "legs", "argonpcpantsbelly3" )
			storage.belly = "3"
		elseif stopWatch > stageInterval then
			entity.setItemSlot( "head", "argonpcheadbelly2" )
			entity.setItemSlot( "chest", "argonpcchestbelly2" )
			entity.setItemSlot( "legs", "argonpcpantsbelly2" )
			storage.belly = "2"
		elseif stopWatch <= stageInterval then
			entity.setItemSlot( "head", "argonpcheadbelly1" )
			entity.setItemSlot( "chest", "argonpcchestbelly1" )
			entity.setItemSlot( "legs", "argonpcpantsbelly1" )
			storage.belly = "1"
		end
		if stopWatch > stageInterval*5.7 then
			stopWatch = stageInterval*5.6
		end
	end
	
	
	
	if entity.isLounging() then
		if fed then
			entity.setItemSlot( "head", "argonpcheadbelly" .. storage.belly .. "blink" )
		else
			entity.setItemSlot( "head", "argonpcheadblink" )
		end
	else
		if fed then
			entity.setItemSlot( "head", "argonpcheadbelly" .. storage.belly )
		else
			entity.setItemSlot( "head", "argonpchead" )
		end
	end
	
	
	
	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
end
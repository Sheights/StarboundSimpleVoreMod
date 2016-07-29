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

	npc.setItemSlot( "head", "argonpcheadbelly1" )
	npc.setItemSlot( "chest", "argonpcchestbelly1" )
	npc.setItemSlot( "legs", "argonpcpantsbelly1" )

	storage.belly = "1"

end

function loseHook()
	
--	if isPlayer then
--		entity.say("^blue;<3")
--	end
	
	npc.setItemSlot( "head", "argonpchead" )
	npc.setItemSlot( "chest", "argonpcchest" )
	npc.setItemSlot( "legs", "argonpcpants" )
	
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
					npc.say("^blue;<3")
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
			npc.setItemSlot( "head", "argonpcheadbelly5" )
			npc.setItemSlot( "chest", "argonpcchest" )
			npc.setItemSlot( "legs", "argonpcpants" )
			storage.belly = "5"
		elseif stopWatch > stageInterval*4 then
			npc.setItemSlot( "head", "argonpcheadbelly5" )
			npc.setItemSlot( "chest", "argonpcchestbelly5" )
			npc.setItemSlot( "legs", "argonpcpantsbelly5" )
			storage.belly = "5"
		elseif stopWatch > stageInterval*3 then
			npc.setItemSlot( "head", "argonpcheadbelly4" )
			npc.setItemSlot( "chest", "argonpcchestbelly4" )
			npc.setItemSlot( "legs", "argonpcpantsbelly4" )
			storage.belly = "4"
		elseif stopWatch > stageInterval*2 then
			npc.setItemSlot( "head", "argonpcheadbelly3" )
			npc.setItemSlot( "chest", "argonpcchestbelly3" )
			npc.setItemSlot( "legs", "argonpcpantsbelly3" )
			storage.belly = "3"
		elseif stopWatch > stageInterval then
			npc.setItemSlot( "head", "argonpcheadbelly2" )
			npc.setItemSlot( "chest", "argonpcchestbelly2" )
			npc.setItemSlot( "legs", "argonpcpantsbelly2" )
			storage.belly = "2"
		elseif stopWatch <= stageInterval then
			npc.setItemSlot( "head", "argonpcheadbelly1" )
			npc.setItemSlot( "chest", "argonpcchestbelly1" )
			npc.setItemSlot( "legs", "argonpcpantsbelly1" )
			storage.belly = "1"
		end
		if stopWatch > stageInterval*5.7 then
			stopWatch = stageInterval*5.6
		end
	end
	
	
	
	if npc.isLounging() then
		if fed then
			npc.setItemSlot( "head", "argonpcheadbelly" .. storage.belly .. "blink" )
		else
			npc.setItemSlot( "head", "argonpcheadblink" )
		end
	else
		if fed then
			npc.setItemSlot( "head", "argonpcheadbelly" .. storage.belly )
		else
			npc.setItemSlot( "head", "argonpchead" )
		end
	end
	
	
	
	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end
end
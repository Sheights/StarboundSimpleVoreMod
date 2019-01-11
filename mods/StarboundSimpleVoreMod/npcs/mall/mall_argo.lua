oldInit = init
oldInteract = interact
oldUpdate = update

mallBelly = 10
mallFace = 10
blinker = 0
changeTimer = 0

function init()
	oldInit()
	mallBelly = math.random(0,5)
	mallFace = math.random(0,5)
end

function update(dt)

	tempupdate = update
	tempinteract = interact
	oldUpdate(dt)

	if mallBelly > 5 then
		mallBelly = math.random(0,5)
	else
		if mallBelly > 0 then
			npc.setItemSlot( "chest", "argonpcchestbelly" .. mallBelly )
			npc.setItemSlot( "legs", "argonpcpantsbelly" .. mallBelly )
		else
			npc.setItemSlot( "chest", "argonpcchest" )
			npc.setItemSlot( "legs", "argonpcpants" )
		end
	end
	
	if mallFace > 5 then
		mallFace = math.random(0,5)
	else
		if mallFace > 0 then
			if blinker < 0.25 then
				npc.setItemSlot( "head", "argonpcheadbelly" .. mallFace .. "blink" )
			else
				npc.setItemSlot( "head", "argonpcheadbelly" .. mallFace )
			end
		else
			if blinker < 0.25 then
				npc.setItemSlot( "head", "argonpcheadblink" )
			else
				npc.setItemSlot( "head", "argonpchead" )
			end
		end
	end
	
	if blinker < 0.25 then
		blinker = blinker + dt
	end
	
	if blinker >= 0.25 and math.random(700) == 1 then
		blinker = 0
	end
	
	if changeTimer > 30 then
		
		if math.random(0,1) == 1 then
			if mallBelly == 0 then
				mallBelly = 5
			elseif mallBelly == 1 then
				mallBelly = 2
			else
				if math.random(0,1) == 1 then
					mallBelly = mallBelly + 1
				else
					mallBelly = mallBelly - 1
				end
			end
			if mallBelly > 5 then
				mallBelly = 0
			end
		end
		mallFace = math.random(0,5)
		changeTimer = 0
	end
				
	
	changeTimer = changeTimer + dt
	
	update = tempupdate
	interact = tempinteract
	
end


	
	
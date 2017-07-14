require "/scripts/vore/npcvore.lua"

animFlag = false
animTimer = 0

isDigest	= true
effect 		= "npcdigestvore"

capacity = 5
duration = 180

playerLines = {}

playerLines[1] = {	"I could use more.",
					"An Amoeba for you. hehehe",
					"I suggest you try and fall asleep in there. Its not my problem if you keep yourself awake too long.",
					"This won't end well for you. You know that right?",
					"I suppose you knew you'd digest in there. Perhaps you wanted that.",
					"Do you like being meals? I see you just jumping into open mouths like its a game. Certainly its a death wish.",
					"This could end badly for you. But right now, just sating my hunger is plenty good for me.",
					"Your death won't be in vain. A meal for me is all you needed to be.",
					"Hate to take such a satisfying meal from someone else, but this is mine now.",
					"You won't be escaping this soon.",
					"Your digestion is taking place, just accept your fate.",
					"Accept being my meal, its what you're meant to be. Now digest like the meal you are.",
					"Digest into a nice, fattening, nutritional slush.",
					"No ones gonna want the gelatinous remnants of your digesting body now. May as well stay and let me absorb you."
}

playerLines["eat"] = {	"Thanks for your sacrifice. I was famished.",
						"You are in for a rough trip.",
						"Just be glad you can see in there. Actually... don't be glad. You should worry a little. or.. a lot.",
						"Let me just savor this taste for a moment.",
						"Oh, such flavor.",
						"Needs some seasoning.",
						"You are really eager to feed me, aren't ya.",
						"Just one of many down my belly."
}

playerLines["die"] = {	"May your remains feed me for a long time.",
						"Aaah.. thats one down and digested. More to go.",
						"Sad to see you go. you will be missed.",
						"*Sighs and rubs his shrinking stomach* Just bones now. Soon there won't even be that.",
						"Just a nice nutritional puddle of slush for me now.",
						"*He belches* Oh, all gone? Such a shame.",
						"All gone, no more. Time to take another."
}
playerLines["request"] = {	"Psst... Everyone's staring...",
							"Did you bathe in marinades or something?",
							"Aah, you went for it, didn't you?",
							"I knew you couldn't resist!",
							"Thanks! I was wanting to eat you, saved me the trouble of hunting you down!",
							"Can you just.. jump in? Right there. Aaaaaaah. yeah. Jump right in."
}

playerLines["release"] = {	"It seems you have survived for another day.",
							"Do come again. I'll be hungry again soon enough.",
							"Not much to say. Was a delight.",
							"I enjoyed your flavor."
}

playerLines["exit"] = {	"Fine... I guess you can leave now.",
						"You'll be back anyway.",
						"Don't slime the place now!",
						"You'll be back. You can't resist the urge to feed me.",
						"Your friend will miss you, don't you want to join them?",
						"Your pre-digested body should heal... eventually.. maybe.",
						"I was done with you, anyway.",
						"I await your inevitable return."
}

function dress() end

function deathHook(input)
	sayLine( playerLines["die"] )
end

function feedHook()
	sayLine( playerLines["eat"] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
end

function requestHook(input)
	sayLine( playerLines["request"] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
end

function digestHook(id, time, dead)
	sayLine( playerLines["release"] )
	if #victim == 5 then
		npc.setItemSlot( "legs", "axonlegsbelly4" )
	elseif #victim == 4 then
		npc.setItemSlot( "legs", "axonlegsbelly3" )
	elseif #victim == 3 then
		npc.setItemSlot( "legs", "axonlegsbelly2" )
	elseif #victim == 2 then
		npc.setItemSlot( "legs", "axonlegsbelly1" )
	else
		npc.setItemSlot( "legs", "axonlegs" )
	end
end

function releaseHook(input, time)
	sayLine( playerLines["exit"] )
	if #victim == 5 then
		npc.setItemSlot( "legs", "axonlegsbelly4" )
	elseif #victim == 4 then
		npc.setItemSlot( "legs", "axonlegsbelly3" )
	elseif #victim == 3 then
		npc.setItemSlot( "legs", "axonlegsbelly2" )
	elseif #victim == 2 then
		npc.setItemSlot( "legs", "axonlegsbelly1" )
	else
		npc.setItemSlot( "legs", "axonlegs" )
	end
end

function updateHook(dt)
	if animFlag then
		if animTimer < 5.0 then
			npc.setItemSlot( "head", "axonheadbelly1" )
		elseif animTimer < 7.0 then
			npc.setItemSlot( "head", "axonheadbelly2" )
		elseif animTimer < 8.5 then
			npc.setItemSlot( "head", "axonheadbelly3" )
		elseif animTimer < 10.0 then
			npc.setItemSlot( "head", "axonheadbelly4" )
		else
			npc.setItemSlot( "head", "axonhead" )
			if #victim > 0 then
				npc.setItemSlot( "legs", "axonlegsbelly" .. #victim )
			else
				npc.setItemSlot( "legs", "axonlegs" )
			end
			animFlag = false
			animTimer = 0
		end
		animTimer = animTimer + dt
	end
	if math.random(700) == 1 and containsPlayer() then
		sayLine( playerLines[1] )
	end
end
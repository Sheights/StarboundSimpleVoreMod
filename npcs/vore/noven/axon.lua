require "/scripts/vore/multivore.lua"

animFlag = false

stopWatch	= { 0, 0, 0, 0, 0 }

animTimer = 0
capacity = 5
duration = 180
playerTimer = 180

request		= { false, false, false, false, false }
victim		= { nil, nil, nil, nil, nil }

voreeffect = "dragonvoremed"

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

function redress()

	digest()
	
end

function digestHook()

	if #victim > 0 then
		entity.setItemSlot( "legs", "axonlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "axonlegs" )
	end
	
end

function feedHook()

	if requested then
		entity.say( playerLines["request"][ math.random( #playerLines["request"] )] )
	else
		entity.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	end
	
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
	
end

function updateHook(dt)

	if animFlag then

		dt = dt or 0.01
		if animTimer < 5.0 then
			entity.setItemSlot( "head", "axonheadbelly1" )
		elseif animTimer < 7.0 then
			entity.setItemSlot( "head", "axonheadbelly2" )
		elseif animTimer < 9.0 then
			entity.setItemSlot( "head", "axonheadbelly3" )
		elseif animTimer < 11.0 then
			entity.setItemSlot( "head", "axonheadbelly4" )
		else
			entity.setItemSlot( "head", "axonhead" )
			if #victim > 0 then
				entity.setItemSlot( "legs", "axonlegsbelly" .. #victim )
			else
				entity.setItemSlot( "legs", "axonlegs" )
			end
			animFlag = false
			animTimer = 0
		end
		
		animTimer = animTimer + dt
	end
	
	if math.random(500) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		entity.say( playerLines[ 1 ][ math.random( #playerLines[ 1 ] ) ] )
	end

end

function forceExit()

	entity.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )

	if #victim > 1 then
		entity.setItemSlot( "legs", "axonlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "axonlegs" )
	end

end
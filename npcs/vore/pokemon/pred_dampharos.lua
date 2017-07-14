require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"

legs[2] = "ampharosnormallegsbelly"

bellyLines = {	"Feel free to wriggle in there, I don't mind <3",
				"I-I'm so big! Look at my belly!",
				"I look even cuter, full of you!",
				"Haha! You'll have to squirm harder if you want out!",
				"You make my belly all bumpy ^pink;<3^white;"
}
gulpLines = {	"Ahh, it feels so nice to swallow down such a tasty traveler!",
				"Looks like I've caught myself a sizable prey!",
				"I-I just wanted to hug you and look what happened!",
				"I love it when my neck swells like that~"
}
gurgleLines = {	"Aww, you've fainted. I'll make sure to add your form to my own body.",
				"Oh no! You didn't hang on long enough! Poor you...",
				"Ahaha! My belly won!"
}
releaseLines = {	"I look forward in eating you again. Everyone needs a warm belly to rest in"
}
requestLines = {	"I have enough room for you if you want to be in my belly. I'll make sure no one can get you.",
					"It doesn't have to be a one way trip. Let me know when you've had enough.",
					"Oh! Of course!"
}
requestLeaveLines = {	"I want to hold you a little longer but if you want to roam around.",
						"Aww. I was just having fun.",
						"My legs need a little break.",
						"It's just so sad to see my tummy so small again."
}
			
function initHook()
	if storage.shiny == nil and math.random(100) == 1 then
		storage.shiny = true
		makeShiny()
	elseif  storage.shiny == true then
		makeShiny()
	else
		storage.shiny = false
	end
end

function deathHook(input)
	sayLine( gurgleLines )
end

function interactHook(input)
	if math.random(4) == 1 then
		world.spawnProjectile( "ampharosprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function digestHook(id, time, dead)
	sayLine( releaseLines )
end

function releaseHook(input, time)
	sayLine( requestLeaveLines )
end

function feedHook()
	sayLine( gulpLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	sayLine( requestLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook(dt)
	if containsPlayer() and math.random(700) == 1 then
		sayLine( bellyLines )
	end
end

function makeShiny()
	npc.setItemSlot( "chest", "ampharosshinychest" )
	npc.setItemSlot( "legs", "ampharosshinylegs" )
	chest[1] = "ampharosshinychest"
	legs[1] = "ampharosshinylegs"
	legs[2] = "ampharosshinylegsfull"
end
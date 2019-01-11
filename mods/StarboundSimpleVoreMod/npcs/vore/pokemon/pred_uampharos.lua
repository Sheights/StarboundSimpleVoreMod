require "/scripts/vore/npcvore.lua"

legs[2] = "ampharosnormallegsbelly"

bellyLines = {	"You're too good to keep you in my belly. I want you to be closer to me.",
				"I'm glowing as much as my tail! Ahehe~",
				"^yellow;*Baaaaaaaahhh*~^white;",
				"Oooh... You're making me tingle all over! I think that's me."
}
gulpLines = {	"Try not to wiggle so much, its hard to squeeze you into my body this way.",
				"Oooh! K-keep doing t-that",
				"I think that is my favorite part~"
}
gurgleLines = {	"Aww, you've fainted. I'll make sure to add your form to my own body.",
				"Oh no! You didn't hang on long enough! Poor you...",
				"Ahaha! My belly won!"
}
releaseLines = {	"You'll make a lovely Mareep. I'm glad to have you a part of my family."
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

function interactHook(input)
	if math.random(4) == 1 then
		world.spawnProjectile( "ampharosprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function digestHook(id, time, dead)
	sayLine( releaseLines )
	world.sendEntityMessage( id, "applyStatusEffect", "npceggbase", 60, entity.id() )
end

function releaseHook(input, time)
	sayLine( requestLeaveLines )
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npceggbase", 60, entity.id() )
	end
end

function feedHook()
	sayLine( gulpLines )
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	sayLine( requestLines )
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
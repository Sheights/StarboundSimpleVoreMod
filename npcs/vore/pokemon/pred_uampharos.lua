require "/scripts/vore/npcvore.lua"

voreeffect = "harpyvore"

audio = false

duration = 60

legs = "ampharosnormallegs"

fulllegs = "ampharosnormallegsbelly"

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
	
	if storage.shiny == nil and math.random(10) == 1 then
		storage.shiny = true
		makeShiny()
	elseif  storage.shiny == true then
		makeShiny()
	else
		storage.shiny = false
	end
	
end

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "ampharosprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function digestHook()
	
	isPlayer = false
	if request then
		npc.say( requestLeaveLines[ math.random( #requestLeaveLines ) ] )
	else
		npc.say( releaseLines[ math.random( #releaseLines ) ] )
	end
	
end

function feedHook()
	
	if request == true then
		npc.say( requestLines[ math.random( #releaseLines ) ] )
	else
		npc.say( gulpLines[ math.random( #gulpLines ) ] )
	end

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( stopWatch < duration or request ) then
		npc.say( bellyLines[math.random(#bellyLines)])
	end

end

function makeShiny()

	npc.setItemSlot( "chest", "ampharosshinychest" )
	npc.setItemSlot( "legs", "ampharosshinylegs" )
	legs = "ampharosshinylegs"
	fulllegs = "ampharosshinylegsfull"

end
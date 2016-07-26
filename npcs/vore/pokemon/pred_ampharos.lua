require "/scripts/vore/npcvore.lua"

legs = "ampharosnormallegs"

fulllegs = "ampharosnormallegsbelly"

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
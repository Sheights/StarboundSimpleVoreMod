require "/scripts/vore/npcvore.lua"

legs = "zoroarknormallegs"

fulllegs = "zoroarknormallegsbelly"

playerLines = {	"I'm so happy you decided to join me <3",
				"Can I borrow a little of you? I lost some of me when I went for a walk yesterday.",
				"There is no way we could be closer. Well, there is one way~",
				"How are you doing in there? I can feel you're scared. Aww don't be. I'll keep you safe.",
				"Relax and be one with me~",
				"I-I couldn't be happier! Thank you."
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

function loseHook()
	
	if isPlayer then
		entity.say("Thank you so much for the time. I hope we can be together again.")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(300) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end

function makeShiny()

	entity.setItemSlot( "head", "zoroarkshinyhead" )
	entity.setItemSlot( "chest", "zoroarkshinychest" )
	entity.setItemSlot( "legs", "zoroarkshinylegs" )
	legs = "zoroarkshinylegs"
	fulllegs = "zoroarkshinylegsbelly"

end
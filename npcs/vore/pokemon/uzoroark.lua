require "/scripts/vore/npcvore.lua"

legs = "zoroarknormallegs"

fulllegs = "zoroarknormallegsbelly"

voreeffect = "harpyvore"

audio = false

duration = 60

playerLines = {	"I'm really starting to enjoy this!",
				"This feels so nice<3",
				"I'm very pleased you could share this with me~",
				"I want you... to stay inside me~",
				"Yes... Rub around in there some more. It's so wonderful!",
				"When you get out... Can you call me 'Mom'?"
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
	
	if isPlayer and stopWatch > 60 then
		entity.say("T-That was amazing. I could get used to this. Thanks, uh, my little pup.")
	elseif isPlayer then
		entity.say("Aww, you have to leave already? Well finish your priorities and get back here. I'm not done with you yet.")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
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
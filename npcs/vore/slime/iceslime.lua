require "/scripts/vore/npcvore.lua"

playerLines = {	"I'm so happy you decided to join me <3",
				"Can I borrow a little of you? I melted slightly yesterday.",
				"There is no way we could be closer. Well, there is one way~",
				"How are you doing in there? I can feel you're scared. Aww don't be. I'll keep you safe.",
				"Relax and be one with me~",
				"I-I couldn't be happier! Thank you.",
				"I hope it isn't too cold. Just think warm thoughts.",
				"I can feel your wamrth. It feels so nice."
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "slimeicelegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "slimeicelegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	legsbelly = {
		name = "slimeicelegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function loseHook()
	
	if isPlayer then
		npc.say("Thank you so much for the time. I hope we can be together again.")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end
	
	if fed then
		if stopWatch >= 45 then
			npc.setItemSlot( "legs", legsbelly )
		end
	end

end
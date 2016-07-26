require "/scripts/vore/npcvore.lua"

isDigest = true

playerLines = {	"I'm so happy you decided to join me <3",
				"Can I borrow a little of you? I lost some of me when I went for a walk yesterday.",
				"There is no way we could be closer. Well, there is one way~",
				"Relax and be one with me~",
				"Mmmm, don't worry about the melting feeling, soon you'll feel amazing~",
				"You'll probably make me look fat with all the mass you'll be adding~",
				"I-I couldn't be happier! Thank you."
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "slimegreenlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "slimegreenlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	legsbelly = {
		name = "slimegreenlegsbelly",
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
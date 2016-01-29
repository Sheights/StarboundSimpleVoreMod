require "/scripts/vore/npcvore.lua"

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...Yum...",
				"...Know your place...",
				"...Natural outcome...",
				"...You food...I eat food...",
				"...I own you..."
}

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "aligatorlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "aligatorlegsbelly2",
		parameters = {
					colorIndex = index
	}}
	
	legsbelly = {
		name = "aligatorlegsbelly1",
		parameters = {
					colorIndex = index
	}}

end

function loseHook()
	
	if isPlayer then
		entity.say("...Come back...")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
	
	if fed then
		if stopWatch >= 45 then
			entity.setItemSlot( "legs", legsbelly )
		end
	end

end
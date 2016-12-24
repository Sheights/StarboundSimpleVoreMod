require "/scripts/vore/npcvore.lua"

playerLines = {	"Squirming prey. Please continue. Warm and good!",
				"Large belly. So full. Heavy and content~",
				"Tasty friend. Wet and trapped. Gleeful and happy!",
				"Eating fun! Will do again. So delicious and sweet!",
				"Full stomach. Almost bursting. Gurgly and groaning~"
}

isDigest = true

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "feneroxlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "feneroxlegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function loseHook()

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end
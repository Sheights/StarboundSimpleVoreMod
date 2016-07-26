require "/scripts/vore/npcvore.lua"

isDigest = true

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "kirhoslegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "kirhoslegsbelly",
		parameters = {
					colorIndex = index
	}}

end
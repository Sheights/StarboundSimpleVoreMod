require "/scripts/vore/npcvore.lua"

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "felinlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "felinlegsbelly",
		parameters = {
					colorIndex = index
	}}

end
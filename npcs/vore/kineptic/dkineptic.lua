require "/scripts/vore/npcvore.lua"

isDigest = true

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "kinepticlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "kinepticlegsbelly",
		parameters = {
					colorIndex = index
	}}

end
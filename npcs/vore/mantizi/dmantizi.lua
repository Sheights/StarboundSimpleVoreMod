require "/scripts/vore/npcvore.lua"

isDigest = true

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "mantizilegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "mantizilegsbelly",
		parameters = {
					colorIndex = index
	}}

end
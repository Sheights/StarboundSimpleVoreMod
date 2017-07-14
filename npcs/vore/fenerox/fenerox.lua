require "/scripts/vore/npcvore.lua"

playerLines = {	"Squirming prey. Please continue. Warm and good!",
				"Large belly. So full. Heavy and content~",
				"Tasty friend. Wet and trapped. Gleeful and happy!",
				"Eating fun! Will do again. So delicious and sweet!",
				"Full stomach. Almost bursting. Gurgly and groaning~"
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	legs[2] = {
		name = "feneroxlegsbelly",
		parameters = {
			colorIndex = index
	}}
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end
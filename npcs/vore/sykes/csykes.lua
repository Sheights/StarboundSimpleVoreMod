require "/scripts/vore/npcvore.lua"

capacity = 1

request		= { false, false }
victim		= { nil, nil }

playerLines = {}

playerLines[1] = {	"Ooh, keep squirming~",
					"Mmm, might just keep you in there all night.",
					"*groans, stroking over your form.*",
					"Nnnngg... lively one, aren't you?"

}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "sykeslegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "sykeslegsballs",
		parameters = {
					colorIndex = index
	}}
end

function feedHook()

end

function loseHook()

	if isPlayer then
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[1][math.random(#playerLines)])
	end

end

function forceExit()
	npc.setItemSlot( "legs", "sykeslegs" )
end

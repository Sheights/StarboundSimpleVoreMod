require "/scripts/vore/npcvore.lua"

capacity = 1

request		= { false, false }
victim		= { nil, nil }

playerLines = {}

playerLines[1] = {	"*groans softly, rubbing over you*",
					"*glorps around you*",
					"Mmm... Sticky in there?",
					"Comfy in there? I'd hope so, hehe.",
					"You're gonna smell like me for a while, hehe.",
					"How's it hanging? Hehe.",
					"How's it feel in there?",
					"*strokes over you through the wet, sticky walls*",
					"Mmm... Always wonderful.",
					"Hehe, keep squirming in there.",
					"Let me know if you want out."
}

playerLines["eat"] = {	"*softly moans as he presses you in.*",
						"Mmm... You're lucky to be in there.",
						"*soft flesh squeezes you downwards into a sticky space.*",
						"*pulls you in slowly, shaft squeezing around you, before you slip down into his warm, sticky sac.*",
						"Ooh... Gonna be fun having you in there.",
						"Mmm... Squirm lots in there."
}

playerLines["exit"] = {	"*presses you up.*",
						"Mmm, you're gonna need to find a bath, I think.",
						"*strokes over himself and lets you out*",
						"Any time.",
						"Come back again, hehe."
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	npc.say( playerLines["exit"][ math.random( #playerLines["eat"] )] )
	
	legs = {
		name = "rakelegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "rakelegsballs",
		parameters = {
					colorIndex = index
	}}
end

function feedHook()

end

function loseHook()

	if isPlayer then
		npc.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[1][math.random(#playerLines)])
	end

end

function forceExit()
	npc.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )
	npc.setItemSlot( "legs", "rakelegs" )
end

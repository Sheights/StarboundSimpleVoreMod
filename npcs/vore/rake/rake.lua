require "/scripts/vore/multivore.lua"

capacity = 2

request		= { false, false }
victim		= { nil, nil }

playerLines = {}

playerLines[1] = {	"*lets out a burp, belly vibrating around you*",
					"*burps, belly squeezing over you*",
					"Ahh... All mine.",
					"Comfy in there?",
					"I'll keep you quite a while.",
					"Just relax and enjoy yourself.",
					"How's it feel in there?",
					"*strokes over you through the warm walls*",
					"Mmm... Always wonderful.",
					"Hehe, keep squirming in there.",
					"Let me know if you want out."
}

playerLines[2] = {	"Oof, can barely keep you two in there.",
					"Hope you two are comfy in there, I know it's a tight fit.",
					"Ahh... Tight, but enjoyable.",
					"*lets out a burp, belly vibrating around you two*",
					"Mmm... All mine.",
					"Let me know if either of you want out."
}

playerLines["eat"] = {	"*gluck*",
						"Mmm, always happy to have you.",
						"*swallows greedily*",
						"*pulls you in slowly, throat squeezing around you, before you slip down into his warm, wet belly.*",
						"Ah, nothing like a full belly.",
						"Mmm, stay a while."
}

playerLines["exit"] = {	"Come back anytime.",
						"Going so soon?",
						"*pushes you out the long way*",
						"You were delicious, come back again.",
						"Belly's always open for you."
}

function digestHook()

	if #victim > 0 then
		npc.setItemSlot( "legs", "rakelegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "rakelegs" )
	end
	
end

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "rakelegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs1 = {
		name = "rakelegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs2 = {
		name = "rakelegsbelly2",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

	npc.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )

	if #victim == 1 then
		npc.setItemSlot( "legs", fulllegs1 )
	else
		npc.setItemSlot( "legs", fulllegs2 )
	end

end

function updateHook()

	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		npc.say( playerLines[ #victim ][ math.random( #playerLines[ #victim ] ) ] )
	end

end

function forceExit()
	npc.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )
	npc.setItemSlot( "legs", "rakelegs" )
end

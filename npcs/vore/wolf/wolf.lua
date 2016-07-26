require "/scripts/vore/multivore.lua"

playerLines = {		"Surprise! Hope you enjoy learning about the digest system of wolves~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up~",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"You'll make a great addition to my pack... Of fat!",
					"Hunters always win, and in this case, they win a tasty meal~"
}

function digestHook()

	if #victim > 0 then
		npc.setItemSlot( "legs", fulllegs1 )
	else
		npc.setItemSlot( "legs", legs )
	end
	
end

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "wolfnewlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs1 = {
		name = "wolfnewlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs2 = {
		name = "wolfnewlegsbelly2",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

	if #victim == 1 then
		npc.setItemSlot( "legs", fulllegs1 )
	else
		npc.setItemSlot( "legs", fulllegs2 )
	end

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		npc.say( playerLines[math.random(#playerLines)])
	end

end
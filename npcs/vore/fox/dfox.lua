require "/scripts/vore/multivore.lua"

capacity = 2

isDigest = true

playerLines = {		"Surprise! Hope you enjoy learning about the digestive system of foxes~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up~",
					"You'll be making my furcoat even more gorgeous soon~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function digestHook()

	if #victim > 0 then
		entity.setItemSlot( "legs", "foxnewlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "foxnewlegs" )
	end
	
end

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "foxnewlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs1 = {
		name = "foxnewlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs2 = {
		name = "foxnewlegsbelly2",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

	if #victim == 1 then
		entity.setItemSlot( "legs", fulllegs1 )
	else
		entity.setItemSlot( "legs", fulllegs2 )
	end

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		entity.say( playerLines[math.random(#playerLines)])
	end

end


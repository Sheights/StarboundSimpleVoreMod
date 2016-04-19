require "/scripts/vore/multivore.lua"

capacity = 2

playerLines = {		"Surprise! I hope you enjoy learning about the digestive system of foxes. <3",
					"Such a scrumptious thing you are~",
					"Ooooo~ I love having you inside my body~",
					"*Yips* Mmm, hope I can find more like you, so delicious~",
					"I hope you aren't making me look TOO fat. *Giggles*",
					"Gonna be a shame to let ya out, just love a full belly. *Kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up.",
					"You would make my furcoat so gorgeous~",
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


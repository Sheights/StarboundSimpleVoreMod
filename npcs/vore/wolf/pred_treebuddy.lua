require "/scripts/vore/multivore.lua"

bellyLines = {	"Can u wiggle some more",
				"Hope ur good in there ",
				"I love u lovely ",
				"U look lovely in there",
				"Oh myh that tickle"
}
gulpLines = {	"Oh myh your tasty",
				"Down the gullet",
				"Nice and full"
}
gurgleLines = {	"That wasnt supposed to happend",
				"You will make nice rumps",
				"A-are you okay ?"
}
releaseLines = {	"Blerf",
					"Better the way in then out",
					"Beuf cya later "
}
requestLines = {	"Want a trip in ?",
					"If ya want ta",
					"A meal wont hurt",
					"*licks his lips *"
}
requestLeaveLines = {	"Ya want out ",
						"Maybe u could stay longuer",
						"Okay let me a second "
}

function digestHook()

	if #victim > 0 then
		entity.setItemSlot( "legs", fulllegs1 )
	else
		entity.setItemSlot( "legs", legs )
	end
	
	if request[1] == false and request [2] == false then
		entity.say( releaseLines[ math.random( #releaseLines ) ] )
	end
	
end

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
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
		entity.setItemSlot( "legs", fulllegs1 )
	else
		entity.setItemSlot( "legs", fulllegs2 )
	end
	
	if request == true then
		entity.say( requestLines[ math.random( #releaseLines ) ] )
	else
		entity.say( gulpLines[ math.random( #gulpLines ) ] )
	end

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		entity.say( bellyLines[math.random(#bellyLines)])
	end

end

function forceExit()
	entity.say( requestLeaveLines[ math.random( #requestLeaveLines ) ] )
end
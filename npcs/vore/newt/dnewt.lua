require "/scripts/vore/npcvore.lua"

isDigest = true

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...I... Love you...",
				"...I'm happy...",
				"...Yum..."
}

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	head = {
		name = "newthead",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "newtlegs",
		parameters = {
					colorIndex = index
	}}
	
	chest = {
		name = "newtchest",
		parameters = {
					colorIndex = index
	}}
	
	fullhead = {
		name = "newtheadbelly1",
		parameters = {
					colorIndex = index
	}}
	
	legsbelly = {
		name = "newtlegsbelly",
		parameters = {
					colorIndex = index
	}}
	
	chestbelly = {
		name = "newtchestbelly",
		parameters = {
					colorIndex = index
	}}
	
	headbelly = {
		name = "newtheadbelly2",
		parameters = {
					colorIndex = index
	}}

end

function loseHook()
	
	if isPlayer then
		entity.say("...Come back...")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
	
	if fed then
		if stopWatch >= 2 then
			entity.setItemSlot( "chest", chest )
			entity.setItemSlot( "legs", legsbelly )
		elseif	stopWatch >=1 then			
			entity.setItemSlot( "chest", chestbelly )
			entity.setItemSlot( "head", headbelly )
		end
	end

end
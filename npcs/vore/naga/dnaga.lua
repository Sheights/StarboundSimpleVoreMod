require "/scripts/vore/multivore.lua"

animFlag = false
isDigest = true

animTimer = 0
capacity = 4

request		= { false, false, false, false }
victim		= { nil, nil, nil, nil }

playerLines = {}

playerLines[1] = {	"...Enjoy a snake's gut...",
					"...You'll feed me for a week...",
					"...Another successful hunt... Now digest...",
					"...Hush... Food must be silent...",
					"...Nutritious..."
}

playerLines[2] = {	"...Enough to last me two weeks...",
					"...Thank the Deity... for these meals...",
					"...The great Quetzalcoatl must be pleased with me...",
					"...First the fur and feathers... then the meat... lastly the bones... such a fine treat..."
}

playerLines[3] = {	"...This will last me... three lovely weeks...",
					"...I must praise the great Quetzalcoatl More...",
					"...So much food... so much... enjoyment...",
					"...'I'm not food' you say?... Hush... don't lie to me... I only eat food..."

}

playerLines[4] = {	"...Praise the great Quetzalcoatl... Praise the snake god...",
					"...may the great Quetzalcoatl feast on your souls...",
					"...This will last me a long month...",
					"...Food for me... do not cry... do not beg... for you are all food... for me..."
}

playerLines["eat"] = {	"...Where food belongs...",
						"...It will be a rough trip...",
						"...Enough waiting... I must eat...",
						"...Your last use...",
						"...Food... as you always have been..."
}

playerLines["exit"] = {	"...The great Quetzalcoatl will not like this...",
						"...You forced yourself out... I must strengthen my grip...",
						"...You won't escape... this is just... temporary...",
						"...Enjoy your freedom while it lasts... my prey..."
}

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	head = {
		name = "nagahead",
		parameters = {
					colorIndex = index
	}}
	
	chest = {
		name = "nagachest",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "nagalegs",
		parameters = {
					colorIndex = index
	}}

	headbelly1 = {
		name = "nagaheadbelly1",
		parameters = {
					colorIndex = index
	}}
	headbelly2 = {
		name = "nagaheadbelly2",
		parameters = {
					colorIndex = index
	}}
	headbelly3 = {
		name = "nagaheadbelly3",
		parameters = {
					colorIndex = index
	}}
	
	chestbelly1 = {
		name = "nagachestbelly1",
		parameters = {
					colorIndex = index
	}}
	chestbelly2 = {
		name = "nagachestbelly2",
		parameters = {
					colorIndex = index
	}}
	chestbelly3 = {
		name = "nagachestbelly3",
		parameters = {
					colorIndex = index
	}}
	chestbelly4 = {
		name = "nagachestbelly4",
		parameters = {
					colorIndex = index
	}}
	
	legsbelly1 = {
		name = "nagalegsbelly1",
		parameters = {
					colorIndex = index
	}}
	legsbelly2 = {
		name = "nagalegsbelly2",
		parameters = {
					colorIndex = index
	}}
	legsbelly3 = {
		name = "nagalegsbelly3",
		parameters = {
					colorIndex = index
	}}
	legsbelly4 = {
		name = "nagalegsbelly4",
		parameters = {
					colorIndex = index
	}}
end

function redress()

	digest()
	
end

function digestHook()

	if #victim == 3 then
		entity.setItemSlot( "legs", legsbelly3 )
	elseif #victim == 2 then
		entity.setItemSlot( "legs", legsbelly2 )
	elseif #victim == 1 then
		entity.setItemSlot( "legs", legsbelly1 )
	else
		entity.setItemSlot( "legs", legs )
	end
	
end

function feedHook()
	
	entity.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
	
end

function updateHook(dt)

	if animFlag then

		dt = dt or 0.01
		if animTimer < 0.5 then
			entity.setItemSlot( "head", headbelly1 )
		elseif animTimer < 1.0 then
			entity.setItemSlot( "head", headbelly2 )
		elseif animTimer < 1.5 then
			entity.setItemSlot( "head", headbelly3 )
		elseif animTimer < 2.0 then
			entity.setItemSlot( "head", head )
			entity.setItemSlot( "chest", chestbelly1 )
		elseif animTimer < 4.0 then
			entity.setItemSlot( "chest", chestbelly2 )
		elseif animTimer < 6.0 then
			entity.setItemSlot( "chest", chestbelly3 )
		elseif animTimer < 8.0 then
			entity.setItemSlot( "chest", chestbelly4 )
		else
			entity.setItemSlot( "chest", chest )
			if #victim == 4 then
				entity.setItemSlot( "legs", legsbelly4 )
			elseif #victim == 3 then
				entity.setItemSlot( "legs", legsbelly3 )
			elseif #victim == 2 then
				entity.setItemSlot( "legs", legsbelly2 )
			elseif #victim == 1 then
				entity.setItemSlot( "legs", legsbelly1 )
			else
				entity.setItemSlot( "legs", legs )
			end
			animFlag = false
			animTimer = 0
		end
		
		animTimer = animTimer + dt
	end
	
	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		entity.say( playerLines[ #victim ][ math.random( #playerLines[ #victim ] ) ] )
	end
end

function forceExit()

	entity.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )
	
	entity.setItemSlot( "legs", legs )

end
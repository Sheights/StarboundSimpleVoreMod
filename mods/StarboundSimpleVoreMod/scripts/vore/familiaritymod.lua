require "/scripts/vore/predprofile.lua"

oldPreserved = tenant.preservedStorage

function tenant.preservedStorage()
	local newtable = {
		names = storage.names,
		freq = storage.freq
	}

	return util.mergeTable(newtable, oldPreserved() or {})
end

function familiarize( name )

	temp = storage.names

	for i=1, #temp do
		if temp[i] == name then
			storage.freq[i] = storage.freq[i] + 1
			temp = storage.freq[i]
			
			if temp < 10 then
				familiarity = 1
			elseif temp < 20 then
				familiarity = 2
			else
				familiarity = 3
			end
			do return end
		end
	end
	
	storage.freq[#temp+1] = 1
	storage.names[#temp+1] = name
	
	familiarity = 1

end

function famModInit()
	
	if storage.names == nil then
		storage.names = {}
		storage.freq = {}
	end

	if storage.profile == nil then
		profile = math.random( #profiles )
		storage.profile = profile
	else
		profile = storage.profile
	end
	
	myProfile = profiles[ profile ]
	
	sayLine(input) = {
		npc.say( input[familiarity][math.random(#input[familiarity])] )
	}
	
end

function famModDeath()
	sayLine( myProfile["death"] )
end

function famModFeed(input)
	familiarize( world.entityName( input ) )
	sayLine( myProfile["consume"] )
end
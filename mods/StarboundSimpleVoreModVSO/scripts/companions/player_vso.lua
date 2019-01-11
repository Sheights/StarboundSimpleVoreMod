
oldinit = init
function init()
	oldinit()
	message.setHandler("vsoForcePlayerSit", function( _, _, sourceEntityId, seatindex ) return player.lounge( sourceEntityId, seatindex ); end )
	message.setHandler("vsoListStatusEffects", function( _, _, sourceEntityId ) return status.activeUniqueStatusEffectSummary() end )
	
	--void player.interact(String interactionType, Json config, [EntityId sourceEntityId])
	--Triggers an interact action on the player as if they had initiated an interaction and the result had returned the specified interaction type and configuration. Can be used to e.g. open GUI windows normally triggered by player interaction with entities. 
	message.setHandler("vsoForceInteract", function( _, _, interactionType, config, sourceEntityId )
		player.interact( interactionType, config, sourceEntityId )
	end )
	
	--[[
	--Try and find a call that can STOP the use of a tech
	message.setHandler("vsoForceCall", function( _, _, fnname, arglist )
		sb.logInfo( "self: player_vso.lua" );
		for k,v in pairs( self ) do
			sb.logInfo( k );
		end
		--sb.logInfo( tostring( tech ) )
		if _ENV[ fnname ] ~= nil then
			if arglist ~= nil then
				_ENV[ fnname ]( unpack( arglist ) )	--apply? hm.	unpack does it for SMALL lists
			else
				_ENV[ fnname ]()
			end
		else
			sb.logInfo("#ERROR vsoForceCall Could not call "..fnname );
		end
	end )
	]]--
	
	message.setHandler("vsoTakeItem", function( _, _, itemname, itemcount )
		if itemcount == nil then itemcount = 1 end
		
		--local allthings = player.inventoryTags()
		--sb.logInfo( "ALL TAGGED ITEMS" )
		--for k,v in pairs( allthings ) do
		--	sb.logInfo( k.." "..tostring( v ) )
		--end
		
		--This is the minimal version...
		--vsoTakeItem
		
		--if the player puts in a BAD ITEM NAME it crashes the VSO...
		
		--if player.hasItem( { name = itemname, count = itemcount }, false ) then
		local res = player.consumeItem( { name = itemname, count = itemcount }, false, false );
		if res ~= nil then
			return res.count == itemcount;
		end
		return false;
		--end
		--return false
	end )
	
	--[[
	message.setHandler("vsoGiveItem", function( _, _, itemname, itemcount )
		if itemcount == nil then itemcount = 1 end
		
		--This is the minimal version...
		while itemcount > 0 do
			player.giveItem( { name = itemname, count = 1 } );
			itemcount = itemcount - 1;
		end
		
	end )
	
	message.setHandler("vsoTakeHeldItem", function( _, _, itemname, itemcount )
		if itemcount == nil then itemcount = 1 end
		
		if player.primaryHandItem().name == itemname then
			if player.consumeItem( player.primaryHandItem(), false, false ) then
				return true
			end
		elseif player.altHandItem().name == itemname then
			if player.consumeItem( player.altHandItem(), false, false ) then
				return true
			end
		end
		
		
		--This version is a hack that DOES remove the item from your hand forcefully... but could cause problems.
		
		--Take ALL of that type of item, the give n - 1 back?
		--Kind of a hack... 
		--	player.giveItem(ItemDescriptor item)
		local hasn = player.hasCountOfItem( { name = itemname }, false );
		
		--sb.logInfo( "has "..tostring( hasn ).." of "..itemname.." want "..tostring( itemcount ) )
		if hasn >= itemcount then
		
			if player.consumeItem( { name = itemname, count = hasn }, false, false ) then
			
				if hasn > itemcount then
					local ncount = (hasn - itemcount);
					while ncount > 0 do
						player.giveItem( { name = itemname, count = 1 } );
						ncount = ncount - 1;
					end
				end
				
				return true;
			end
		end
		
		
		return false;
		
	end )
	]]--
	
end
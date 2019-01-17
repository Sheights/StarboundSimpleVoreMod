--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/util.lua"

totalBought = 0;
totalBoughtCost = 0;

--Undocumented, but does what you need with "itemslot" gui elements. Found in keytradergui.config
--  widget.setItemSlotItem("itmTradeItem", self.tradeItem)
--  -> Make a more correct store interface then
  
--"rarity" ->
rarityMap = { 
	Common = "/interface/inventory/itembordercommon.png"
	,Uncommon = "/interface/inventory/itemborderuncommon.png"
	,Rare = "/interface/inventory/itemborderrare.png"
	,Legendary = "/interface/inventory/itemborderlegendary.png"
	,Essential = "/interface/inventory/itemborderessential.png"
	
	,Disabled = "/interface/inventory/grayborder.png"
	
	,Thin = "/interface/inventory/itemlinkindicator.png"
	,None = "/interface/inventory/emptier.png"
	
	--Other categories?
	
	--"/interface/inventory/itemborderessential.png"	--Essential
	--"/interface/inventory/itemborderlegendary.png"	--Legendary
	--"/interface/inventory/itemborderrare.png"			--Rare
	--"/interface/inventory/itemborderuncommon.png"		--Uncommon
	--"/interface/inventory/itembordercommon.png"		--Common
	
	--"/interface/inventory/grayborder.png"				--Disabled / not accessible
	--"/interface/inventory/itemlinkindicator.png"		--Thin border?
	--"/interface/inventory/portrait.png"				--Portrait border?
	--"/interface/inventory/redborder.png"				--Red border??
}

function updateItemList()

	--[[
	Remove this because it dont work. Copying ocllections gui method
	"itemIcon": {
		"type": "itemslot",
		"position": [1, 1],
		"callback": "null"
	},
	]]--
	
	local maxupdates = 32;
	while updateitem <= updateitemmax do
		
		local v = items[ updateitem ]
		
		--local itype = root.itemType( v.item.name )
		--local itags = root.itemTags( v.item.name )		--root.itemHasTag(v.item.name, String tagName)
		local ircon = root.itemConfig( v.item.name, v.item.rarity )	--, [float level], [unsigned seed])
		
		--ircon.parameters
			--timeToRot=5400
		--ircon.config
			-- foodValue=10, 
			-- price=4, 
			-- eventCategory=cookingIngredient, 
			-- builder=/items/buildscripts/buildfood.lua, 
			-- inventoryIcon=alienmeat.png, 
			-- description=A raw slab of weird, stringy alien meat. Maybe I should cook it., 
			-- blockingEffects=table: 000000003FD5C380, 
			-- effects=table: 000000003FD5C080, 
			-- rarity=Common, 
			-- maxStack=1, 
			-- itemAgingScripts=table: 000000003FD5C2C0, 
			-- shortdescription=Raw Steak, 
			-- tooltipFields=table: 000000003FD5C440, 
			-- rottingMultiplier=0.5, 
			-- category=food, 
			-- tooltipKind=food, 
			-- itemName=alienmeat, 
		--ircon.directory	--'/items/generic/meat/'
		
		--local sad = "";
		--for k,v in pairs( ircon.parameters ) do
		--	sad = sad..k.."="..tostring(v)..", "
		--end
		--sb.logInfo( sad );
		
		--Json root.itemConfig(ItemDescriptor descriptor, [float level], [unsigned seed])
		--Generates an item from the specified descriptor, level and seed and returns a JSON object containing the directory, config and parameters for that item. 

		--background
		
		--You can add directives?????
		--local highlightDirectives = string.format("?multiply=FFFFFF%2x", math.floor(opacity * 255))
		--widget.setImage("imgSelected", self.selectionImage..highlightDirectives)
		
		--sb.logInfo( icon );
		--widget.setImage( pathtome..".itemIcon", icon )	--Why isn't this working? Hm. Its the same as all the other examples.
		--widget.setImageScale( pathtome.."itemIcon", 1.0 )
		
		local pathtome = "typeTabs.tabs.buy.scrollArea.itemList."..tostring( itemNames[updateitem].name );
		
		local icon = util.absolutePath( ircon.directory, ircon.parameters.inventoryIcon or ircon.config.inventoryIcon )
				
		local dorare = rarityMap[ ircon.config.rarity ];
		if dorare == nil then
			dorare = rarityMap[ "Thin" ];
		end
		local available = true;
		
		--is this thing DISABLED? For whatever reason? If so change it (species mismatch, lack of funds)
		
		local whatsit = root.imageSize( icon );	--obviously we know what this is.
		
		local recto = root.nonEmptyRegion( icon )	--buh??
		
		if whatsit ~= nil then
		
			sb.logInfo( icon.." " ..tostring( whatsit[1] ).." " ..tostring( whatsit[2] ) );
		else
			sb.logInfo( "bad image: "..icon )
		end
		
		widget.setVisible( pathtome..".unavailableoverlay", not available );	--available!
		
		widget.setImage( pathtome..".imageIconMid", icon )
		
		widget.setImage( pathtome..".imageIconBack", dorare )
		
		widget.setText( pathtome..".itemName", ircon.config.shortdescription )
		
		widget.setText( pathtome..".priceLabel", tostring( ircon.config.price ) )
		
		widget.setData( pathtome, {
			index = updateitem 
			,price = ircon.config.price
			,available = available
		})	--Hmmmm
  
		updateitem = updateitem + 1;
		
		maxupdates = maxupdates - 1;
		if maxupdates < 0 then
			break;
		end
	end
end

function makeItem( sourceid )

	local inos = items[ sourceid ].item;
	
	local ircon = root.itemConfig( inos.name, inos.rarity )
	
	world.spawnItem( inos, world.entityPosition( targetId ), 1, ircon.parameters )
	
end

function init( )
	
	targetId = config.getParameter("vsoOwnerID");
	playerId = config.getParameter("vsoInteractId")
	
	--interactdat.vsoOwnerID = entity.id()
	--interactdat.vsoInteractId = args["sourceId"];

	--return { interactopt, interactdat }
	
	--Nothing selected initally
	widget.setText( "typeTabs.tabs.buy.tbCount", "1" )
	widget.setText( "typeTabs.tabs.buy.lblBuyTotal", "0" )
					
	paneLayoutOverride = config.getParameter("paneLayoutOverride");
	sellFactor = config.getParameter("sellFactor");
	items = config.getParameter("items");
	
	updateitem = 1;
	updateitemmax = #items;
	
	itemNames = {}
    widget.clearListItems( "typeTabs.tabs.buy.scrollArea.itemList" )
	for k,v in pairs( items ) do
	
		--local ircon = root.itemConfig( v.item.name, v.item.rarity )
		--ircon.config.price
	
		local name = widget.addListItem( "typeTabs.tabs.buy.scrollArea.itemList" )	--FILL IT with items... but the names of which are???
		--items.guiname = name
		table.insert( itemNames, { sourceid=k, name=name } );
	end
	
	--Second tab has.... something in it?
    widget.clearListItems( "typeTabs.tabs.buy2.scrollArea.itemList" )
	local name = widget.addListItem( "typeTabs.tabs.buy2.scrollArea.itemList" )	--FILL IT with items... but the names of which are???
	
end

function update(dt)

	if world.entityExists( targetId ) then
	
		updateItemList()
		
	else
		pane.dismiss()
	end
end

function uninit( )
	--Notify?
end

function parseCountText( arg1, arg2, arg3 ) 
	sb.logInfo( "parseCountText "..tostring( arg1 ).." "..tostring( arg2 ) );
end

function buy( buttonname ) 

	if buttonname == "btnBuy" then
		
		--Which TAB is selected first of all?
		--Uh
		
		local listname = "typeTabs.tabs.buy.scrollArea.itemList";
		
		local guiname = widget.getListSelected( listname )
		
		local wdata = widget.getData( listname.."."..guiname )	--Index stored on that widget
		
		if wdata.available then
		
			--wdata.price
		end
			
			
		if guiname == nil then
			--Nothing selected
		else
		
			local widgetname = listname.."."..guiname	--full name of widget
			
			local idex = widget.getData( widgetname ).index	--Index stored on that widget
			
			widget.removeListItem( listname, (idex - 1) )	--REMOVE that list item... with 0 offset indicies
			
			local oldmaxlen = #itemNames;	--old item list length
			
			--interesting....
			makeItem( itemNames[ idex ].sourceid )
			
			
			totalBought = totalBought + 1;
			totalBoughtCost = totalBoughtCost + 0;
			
			
			table.remove( itemNames, idex );	--Fix names data
			
			if idex < oldmaxlen then	--if we didnt remove the END of the list
			
				widget.setListSelected( listname, itemNames[ idex ].name )	--Fix it
				
				--Update ALL INDEXES past this one...
				local idexmax = #itemNames;
				local delidex = idex;
				while delidex <= idexmax do
				
					local olddata = widget.getData( listname.."."..itemNames[ delidex ].name )
					olddata.index = delidex;
					widget.setData( listname.."."..itemNames[ delidex ].name, olddata )
					delidex = delidex + 1;
				end
			else
				--removed end of list
			end
		end
	end
end

function tabSelected( arg1, arg2, arg3 ) 

	sb.logInfo( "tabSelected "..tostring( arg1 ).." "..tostring( arg2 ) );
end

function buySelected( arg1, arg2, arg3 ) 

	--arg1 = "itemList"
	--Update STUFF with selection:
	
	sb.logInfo( "buySelected "..tostring( arg1 ).." "..tostring( arg2 ) );
	
	widget.setText( "typeTabs.tabs.buy.lblBuyTotal", tostring( 0 ) )	--Clear out price totals
				
	if arg1 == "itemList" then
		local listname = "typeTabs.tabs.buy.scrollArea.itemList";
		local guiname = widget.getListSelected( listname )
		if guiname ~= nil then
			
			local wdata = widget.getData( listname.."."..guiname )	--Index stored on that widget
			
			if wdata.available then
			
				widget.setText( "typeTabs.tabs.buy.lblBuyTotal", tostring( wdata.price ) )
			end
				
			--Hmmm maybe this "setdata" thing actually handles the icons for me???? Hm.
			--widget.setText( "typeTabs.tabs.buy.tbCount", "1" )
			--widget.setText( "typeTabs.tabs.buy.lblBuyTotal", "0" )
			
			--widget.setListSelected( listname, itemNames[ idex ].name )	--Fix it
		end
	end
	
end

spinCount = {};	--What is this hack

function spinCount.up( arg1, arg2, arg3 ) 

	if arg1 == "up" then
		--
	end

	sb.logInfo( "spinCount.up "..tostring( arg1 ).." "..tostring( arg2 ) );
end

function spinCount.down( arg1, arg2, arg3 ) 
	if arg1 == "down" then
		--
	end

	sb.logInfo( "spinCount.down "..tostring( arg1 ).." "..tostring( arg2 ) );
end

function countChanged( arg1, arg2, arg3 ) 
	sb.logInfo( "countChanged "..tostring( arg1 ).." "..tostring( arg2 ) );
end
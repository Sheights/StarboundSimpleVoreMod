--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Zovoroth

require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
  self.defaultPillIcon = config.getParameter("defaultPillIcon");

  self.itemList = "itemScrollArea.itemList"
  self.pillList = "pillScrollArea.pillList"

  
  self.itemSet = {};

  self.spovItems = {}
  self.selectedItem = nil
  self.selectedItemLastUid = nil
  self.selectedPill = nil
  --populateItemList()
  self.changedanything = true;
  
  --we dont have "pane" here so...
  --sb.logInfo( pane );
  --sb.logInfo( pane.sourceEntity() )
  --we have "player" context which is crazy.
  --we just the the object id that the player interacted with.
  
  --animator.setAnimationState("bodyState", "opening");

	--world.sendEntityMessage(pane.sourceEntity(), "smash")
	--world.callScriptedEntity( 
	--dialogConfig.sourceEntityId = entityId
	self.ownerid = config.getParameter( "ownerId", nil );
	world.sendEntityMessage( self.ownerid, "setAnimationState", "bodyState", "opening" );

  widget.setButtonEnabled("enhanceButton", false);
end

function uninit()

	world.sendEntityMessage( self.ownerid, "setAnimationState", "bodyState", "closing" );
  --animator.setAnimationState("bodyState", "closing");
  
  --If player left a pill in the slot, give it back
  if self.itemSet["pillInput"] then
    player.giveItem(self.itemSet["pillInput"]);
    self.itemSet["pillInput"] = nil;
  end
end

function update(dt)

	--Probably only once every so often really... maybe once a second or so? Hm.
	--ACTUALLY do NOT change this if you can. it'll invalidate selections if you change this.
	if self.changedanything then
		self.changedanything = false;
		populateItemList()
		populatePillList()
	end
end

function populateItemList()
  --Problem: "items with tags" doesnt help a lot for "what item are we changing"
  --	getItemWithParameter
  --	 root.itemTags(String itemName) --applies for a GENERAL item name.
  --
  
  local spovItems = player.itemsWithTag("spovpillable");--"spov");	--ONLY pill able spov's can be pilled.
  --Come up with some sorting criteria?
  --[[
  table.sort(spovItems, function(a, b)
    return vehicleDurability(a) < vehicleDurability(b)
  end)
  ]]--
  
  widget.setVisible("emptyLabel", #spovItems == 0)

  if true then--not compare(spovItems, self.spovItems) then
    self.spovItems = spovItems
    widget.clearListItems(self.itemList)

    self.selectedItem = nil
	
    for i,itemdat in pairs(self.spovItems) do	--HEY! You cant' use the word "item" it is reserved!
      --local config = root.itemConfig(itemdat.name)	--This isnt right either, because this GENERATES a config file. This is a "default" thing.
      local config = root.itemConfig( itemdat )	--Itemdata IS a descriptor so this should work.
	  
	  
		--This is the key: parameters.scriptStorage.myvehicle
		
		--Icon: parameters.scriptStorage.vso.itemConfigOverride.inventoryIcon[1].image
		--descr: parameters.scriptStorage.vso.itemConfigOverride.description
		--descr: parameters.scriptStorage.vso.itemConfigOverride.subtitle
		--descr: parameters.scriptStorage.vso.itemConfigOverride.lowerleft
		--descr: parameters.scriptStorage.vso.itemConfigOverride.price
		
		--sb.logInfo(sb.printJson(itemdat));
		--sb.logInfo(sb.printJson(config));
		--config.parameters = itemdat.parameters;	--Hack to make a UNIQUE item. because itemdata HAS: parameters, count, name.
		--Where as config does NOT have this information.
		--{"parameters":{"scriptStorage":{"myvehicle":153965,"vso":{"pills":{"digest":{"icon":"/items/spov/pills/spovpilldigest.png","description":"Digest prey at a steady rate.","name":"Digestion"}},"burpsloaded":0,"health":100,"_vsoSpawnOwner":153964,"belly":30,"colorReplaceMap":{"a7d485":"b5b5b5","5fab55":"808080","338033":"555555","18521a":"303030"},"name":"Rexo","_vsoSpawnOwnerUID":"fe0b1f99f9a873e6d570b0da171e6cb0","_vsoSpawnOwnerName":"spovspawnernormaldino","itemConfigOverride":{"largeImage":"/vehicles/spov/simpledino/normaldino.png:idle.1?replace=18521a=303030;338033=555555;5fab55=808080;a7d485=b5b5b5;","itemTags":["spovpillable"],"inventoryIcon":[{"image":"/vehicles/spov/simpledino/normaldinoicon.png?replace=18521a=303030;338033=555555;5fab55=808080;a7d485=b5b5b5;","position":[0,0]}],"description":"Rexo is a happy dinosaur and it likes to eat meat! Try feeding it!","lowerleft":"Belly: 30.0","subtitle":"Rexo","price":5000},"feedstats":{"missed":{"people":0,"floormeats":0,"handmeats":0},"toured":{"people":0},"offered":{"people":0,"floormeats":0,"handmeats":0},"eaten":{"people":0,"floormeats":0,"handmeats":0},"teased":{"people":0,"floormeats":0,"handmeats":0}}},"uniqueId":"fe0b1f99f9a873e6d570b0da171e6cb0"}},"count":1,"name":"spovspawnernormaldino"}
	
	  local newwidgetname = widget.addListItem( self.itemList )
	 
	  --sb.logInfo( newwidgetname );
	  
      local listItem = string.format( "%s.%s", self.itemList, newwidgetname )
	  
	  --sb.logInfo( listItem );
	  
      local name = config.config.shortdescription or config.parameters.scriptStorage.vso.itemConfigOverride.description
      local icon = config.parameters.scriptStorage.vso.itemConfigOverride.inventoryIcon[1].image or config.parameters.inventoryIcon or config.config.inventoryIcon
      --icon = util.absolutePath(config.directory, icon)
      --local subtitle = config.parameters.scriptStorage.vso.itemConfigOverride.description or config.config.shortdescription
	  local subtitle = config.parameters.scriptStorage.vso.itemConfigOverride.subtitle or config.parameters.subtitle or config.config.subtitle
      local icon = config.parameters.scriptStorage.vso.itemConfigOverride.inventoryIcon[1].image or config.parameters.inventoryIcon or config.config.inventoryIcon
      local lowerleft = config.parameters.scriptStorage.vso.itemConfigOverride.lowerleft or config.parameters.lowerleft or config.config.lowerleft

	  
	  
      widget.setText(string.format("%s.itemName", listItem), name)
      widget.setImage(string.format("%s.itemIcon", listItem), icon)
      widget.setText(string.format("%s.itemSubtitle", listItem), subtitle)
      widget.setText(string.format("%s.itemLowerLeft", listItem), lowerleft)
      
      widget.setData(listItem, i)

		if config.parameters.scriptStorage.myvehicle == self.selectedItemLastUid then
			if self.selectedItemLastUid ~= nil then
				self.selectedItem = newwidgetname;
			end
			--sb.logInfo( tostring( config.parameters.scriptStorage.myvehicle ) );
			--sb.logInfo( tostring( self.selectedItemLastUid ) );
		end

    end
	
	if self.selectedItem ~= nil then
		widget.setListSelected( self.itemList, self.selectedItem )
		validatePill();
		
	end
			
  end
  
  self.selectedItemLastUid = nil
  
end

function populatePillList()
  if self.selectedItem == nil then
  
	--Please wipe out pill list!
    widget.clearListItems(self.pillList)

    return;
  end

  local itemData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem))
	--local listItem = string.format( "%s.%s_%s", self.itemList, widget.addListItem(self.itemList),tostring( i ) )
	  
  local spovItem = self.spovItems[itemData]

  local pillItems = spovItem.parameters.scriptStorage.vso.pills
  local anyPills = false;
  for k,v in pairs(pillItems) do
    anyPills = true;
    break;
  end
  widget.setVisible("pillUnselectedLabel", false);
  widget.setVisible("pillEmptyLabel", not anyPills);

  if not compare(pillItems, self.pillItems) then
    self.pillItems = pillItems
    widget.clearListItems(self.pillList)

    for i,itemdat in pairs(self.pillItems) do	--HEY! You cant' use the word "item" it is reserved!
      local pillItem = string.format("%s.%s", self.pillList, widget.addListItem(self.pillList));
      local name = itemdat.name or i;
      local icon = itemdat.icon or self.defaultPillIcon;
      local description = itemdat.description or "";
	  local valuestr = ""
	  if itemdat.value ~= nil then
		value = itemdat.value 
		valuestr = " ("..tostring( value)..")"
	  end

      widget.setText(string.format("%s.itemName", pillItem), name..valuestr)
      widget.setImage(string.format("%s.itemIcon", pillItem), icon)
      widget.setText(string.format("%s.itemDescription", pillItem), description)
	  --"value" for pill? Hm.

      widget.setData(pillItem, i);
    end
  end
end

function itemSelected()
  local listItem = widget.getListSelected(self.itemList)
  self.selectedItem = listItem

  local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem))
  local spovItem = self.spovItems[selectedData]
 --sb.logInfo(sb.printJson(spovItem));

  if listItem then
    populatePillList();
    validatePill();
  end
end

function doEnhance( )
  --Double-check!
  if validatePill() then
    local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem))
    local spovItem = self.spovItems[selectedData]

    local currentPill = self.itemSet["pillInput"];
    local itemConfig = root.itemConfig(currentPill);
    local pillAdd = itemConfig.parameters.pillAdd or itemConfig.config.pillAdd;
    local pillRemove = itemConfig.parameters.pillRemove or itemConfig.config.pillRemove;
    
    --local pillRemoveTags = itemConfig.parameters.pillRemoveTags or itemConfig.config.pillRemoveTags;
    --local pillRemoveRandom = itemConfig.parameters.pillRemoveRandom or itemConfig.config.pillRemoveRandom;
	
    --Destroy the old spov and apply the pill effect to a copy
	if spovItem then
	
		if pillAdd or pillRemove then
		  local enhancedItem = copy(spovItem);
		  --Remove pill effects
		  for i = 1, #pillRemove do
			local key = pillRemove[i];
			if enhancedItem.parameters.scriptStorage.vso.pills[key] then
			  enhancedItem.parameters.scriptStorage.vso.pills[key] = nil;
			end
		  end
		  
		  --Add new pill effects
		  for k,v in pairs(pillAdd) do
			enhancedItem.parameters.scriptStorage.vso.pills[k] = v;
		  end
		  --Decrement pill count by 1
		  if currentPill.count > 1 then
			currentPill.count = currentPill.count - 1;
			widget.setItemSlotItem("pillInput", currentPill);
		  else
			--No more pills, so wipe them out
			widget.setItemSlotItem("pillInput", nil);
			self.itemSet["pillInput"] = nil;
		  end
		  --sb.logInfo( sb.printJson( enhancedItem ) );
		  
			--okay but...
			--sb.logInfo( "taking exact: " );
			--sb.logInfo( sb.printJson( spovItem ) );
			
			if player.consumeItem( spovItem, true, true ) then		--MUST BE AN EXACT MATCH please. However, this checks the PARAMETERS. maybe only one level deep of the parameters.
				self.selectedItemLastUid = enhancedItem.parameters.scriptStorage.myvehicle
				--sb.logInfo( "Last UID: "..tostring( self.selectedItemLastUid ) )
				--sb.logInfo( sb.printJson( spovItem ) );	
				--enhanceditem: {"parameters":{"scriptStorage":{"myvehicle":92130,"vso":{"pills":{},"burpsloaded":0,"health":100,"_vsoSpawnOwner":92129,"belly":29.9757,"name":"Rexo","colorReplaceMap":{"a7d485":"d29ce7","5fab55":"a451c4","338033":"6a2284","18521a":"320c40"},"_vsoSpawnOwnerName":"spovspawnernormaldino","itemConfigOverride":{"largeImage":"/vehicles/spov/simpledino/normaldino.png:idle.1?replace=5fab55=a451c4;338033=6a2284;18521a=320c40;a7d485=d29ce7;","itemTags":["spovpillable"],"inventoryIcon":[{"image":"/vehicles/spov/simpledino/normaldinoicon.png?replace=5fab55=a451c4;338033=6a2284;18521a=320c40;a7d485=d29ce7;","position":[0,0]}],"lowerleft":"Belly: 29.97","description":"Rexo is a happy dinosaur and it likes to eat meat! Got any meat?","subtitle":"Rexo","price":5000},"feedstats":{"missed":{"people":0,"floormeats":0,"handmeats":0},"offered":{"people":0,"floormeats":0,"handmeats":0},"toured":{"people":0},"eaten":{"people":0,"floormeats":0,"handmeats":0},"teased":{"people":0,"floormeats":0,"handmeats":0}}}}},"count":1,"name":"spovspawnernormaldino"}
				--spovItem: {"parameters":{"scriptStorage":{"myvehicle":92151,"vso":{"pills":{"digest":{"icon":"/items/spov/pills/spovpilldigest.png","description":"Digest prey at a steady rate.","name":"Digestion"}},"burpsloaded":0,"health":100,"_vsoSpawnOwner":92149,"belly":30,"name":"Rexo","colorReplaceMap":{"a7d485":"96cbe7","5fab55":"5588d4","338033":"344495","18521a":"1a1c51"},"_vsoSpawnOwnerName":"spovspawnernormaldino","itemConfigOverride":{"largeImage":"/vehicles/spov/simpledino/normaldino.png:idle.1?replace=5fab55=5588d4;338033=344495;18521a=1a1c51;a7d485=96cbe7;","itemTags":["spovpillable"],"inventoryIcon":[{"image":"/vehicles/spov/simpledino/normaldinoicon.png?replace=5fab55=5588d4;338033=344495;18521a=1a1c51;a7d485=96cbe7;","position":[0,0]}],"lowerleft":"Belly: 30.0","description":"Rexo is a happy dinosaur with a big appetite! Got any meat?","subtitle":"Rexo","price":5000},"feedstats":{"missed":{"people":0,"floormeats":0,"handmeats":0},"toured":{"people":0},"offered":{"people":0,"floormeats":0,"handmeats":0},"eaten":{"people":0,"floormeats":0,"handmeats":0},"teased":{"people":0,"floormeats":0,"handmeats":0}}}}},"count":1,"name":"spovspawnernormaldino"}

				player.giveItem( enhancedItem );
			else
				--something went wrong.
			end
			
			--Show default?
			widget.setVisible("pillUnselectedLabel", true);
			widget.setVisible("pillEmptyLabel", false);
			
			--widget.setListSelected( self.itemList, nil )	--should clear selection EVEN if something didnt change. Also this doesnt work so, bollocks.
			
			--self.selectedItemLastUid
			
			self.selectedItem = nil;	--Remove selection and reshow because we can't guarantee order or item id at all after this.
			
		end
		
		self.changedanything = true;
	end
	
    --populateItemList();
    --populatePillList();
  end
end

function swapItem(widgetName)
  local currentItem = self.itemSet[widgetName];
  local swapItem = player.swapSlotItem();

  --Get full item details
  local itemConfig = root.itemConfig(swapItem);
  if not swapItem or itemConfig then
    --Make sure this counts as a pill
	
	--Pills must have some things defined?
	local props = { "pillAdd", "pillRemove" }--,  "pillExclude" ]
	local hascount = 0;
	if itemConfig ~= nil then
		if itemConfig.parameters ~= nil then
			for k,v in pairs( props ) do
				if itemConfig.parameters[v]~=nil then
					hascount = hascount + 1;
				end
			end
		end
		if itemConfig.config ~= nil then
			for k,v in pairs( props ) do
				if itemConfig.config[v]~=nil then
					hascount = hascount + 1;
				end
			end
		end
	end
	
    if not swapItem or hascount > 0 then--itemConfig.parameters.pillAdd or itemConfig.config.pillAdd or itemConfig.parameters.pillRemove or itemConfig.config.pillRemove then
      player.setSwapSlotItem(currentItem)
      widget.setItemSlotItem(widgetName, swapItem)
      self.itemSet[widgetName] = swapItem

      if widgetName == "pillInput" then
        pillInputChanged()
      end
    end
  end
end

function pillInputChanged()
  validatePill();
end

function canUsePills()

	local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem));
	local spovItem = self.spovItems[selectedData];
	local itemconf = root.itemConfig( spovItem.name );

	--spovpillable
	
	if itemconf.config.spov ~= nil then
		if itemconf.config.spov.pillsAdd ~= nil then
			local allowedpillsadd = itemconf.config.spov.pillsAdd;
			
			return allowedpillsadd;
		end
	end
	
	return nil;
end

function canUseCurrentPill( allowpilldict )

	local currentPill = self.itemSet["pillInput"];
  
	local valid = false;	---By default, if you DONT SPECIFY you cant add pills.
		
	--What is the currentPill "adding"? thatis all 
	local itemConfig = root.itemConfig(currentPill);
	local itempillAdd = itemConfig.parameters.pillAdd or itemConfig.config.pillAdd;
	if itempillAdd ~= nil then
		
		valid = true;
		local paircount = 0;
		for pk, pv in pairs( itempillAdd ) do
			paircount = paircount + 1;
			if allowpilldict[ pk ] ~= nil then 
				--ALL adds must be valid.
			else
				valid = false;	--No good.
				break;
			end
		end
	end
	return valid;

end

function validatePill()
  local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem));
  local spovItem = self.spovItems[selectedData];
  local currentPill = self.itemSet["pillInput"];
  local valid = false;

  local allowedpillsadd = false;
  local canusecurrentpill = false;
  if spovItem and currentPill then
	
    --Do advanced logic here!
	--Is this pill type APPLICABLE to the current SPOV? Hm...
	--spovItem.name
	local itemconf = root.itemConfig( spovItem.name );
	--sb.logInfo( sb.printJson( itemconf ) )
	--{"parameters":{},"directory":"/objects/vore/spov/","config":{"colorOptions":[{"d84000":"d84000","a0f0f0":"a0f0f0","203880":"203880","1050a8":"1050a8","80d0e0":"80d0e0","60a0d8":"60a0d8","3070c0":"3070c0","f8a800":"f8a800","f8f800":"f8f800"},{"d84000":"d84000","a0f0f0":"a0f0a0","203880":"203800","1050a8":"205818","80d0e0":"68e860","60a0d8":"58b850","3070c0":"408038","f8a800":"c86800","f8f800":"c89000"}],"description":"Summon a hungry little lizard with a long, sticky tongue!","itemName":"spovspawnerPakkunLizard","objectName":"spovspawnerPakkunLizard","isContainer":false,"tooltipSubtitle":"SPOV Summoner","isWired":false,"orientations":[{"imagePosition":[-40,0],"flipImages":true,"image":"/vehicles/spov/PakkunLizard/PakkunLizard.png:silhouette","spaceScan":0.1,"direction":"left","anchors":["bottom"]},{"imagePosition":[-40,0],"image":"/vehicles/spov/PakkunLizard/PakkunLizard.png:silhouette","direction":"right","spaceScan":0.1,"anchors":["bottom"]}],"price":500,"health":5,"inventoryIcon":"/vehicles/spov/PakkunLizard/PakkunLizardicon.png","rarity":"Rare","shortdescription":"SPOV Pakkun Lizard","race":"generic","interactive":false,"retainObjectParametersInItem":true,"colonyTags":["vore"],"npcToy":{"preciseStandPositionRight":[4,0],"preciseStandPositionLeft":[-4,0],"influence":["approach","leave"],"maxNpcs":1,"defaultReactions":{"leave":[[1,"smile"],[1,"annoyed"],[1,"laugh"]],"approach":[[1,"laugh"]]}},"scannable":false,"animation":"spovspawner.animation","animationParts":{"bg":"/vehicles/spov/PakkunLizard/PakkunLizard.png:silhouette"},"builder":"/scripts/vore/spovitembuilder.lua","allowScanning":false,"printable":false,"tooltipKind":"vso","spov":{"template":{},"types":["spovPakkunLizard"],"position":[0,4,0,4]},"inspectable":false,"objectImage":"/vehicles/spov/PakkunLizard/PakkunLizard.png:idle.1","category":"other"}}
 
	allowedpillsadd = canUsePills();
	if allowedpillsadd ~= nil then
		canusecurrentpill = canUseCurrentPill( allowedpillsadd ) 
		valid = canusecurrentpill
	else
		valid = false;
	end
	--[[
	if itemconf.config.spov ~= nil then
		if itemconf.config.spov.pillsAdd ~= nil then
			local allowedpillsadd = itemconf.config.spov.pillsAdd;
			
			--sb.logInfo( sb.printJson( allowedpillsadd ) )
			--{"digest":{},"softdigest":{},"heal":{}}  or nil
			
		else
			--valid = true;	--Nothing specified soooo assume NO PILLS for you.
		end
	end
	]]--
	
  end

  widget.setButtonEnabled("enhanceButton", valid);

  --Explain why it is or is not valid.
  if not valid then
    if currentPill ~= nil then
		local pillconfig = root.itemConfig( currentPill )	--Itemdata IS a descriptor so this should work.
		local dispname = pillconfig.config.shortdescription or pillconfig.config.itemName
		if dispname ~= nil then
		
		else
			dispname = "Pill"
		end
		
		if not allowedpillsadd and not canusecurrentpill then
			widget.setText( "pillAttemptLabel", "Pills not supported." )
		elseif allowedpillsadd and not canusecurrentpill then
			widget.setText( "pillAttemptLabel", dispname.." not usable." )
		elseif allowedpillsadd and canusecurrentpill then
			widget.setText( "pillAttemptLabel", dispname.." is valid!" )
		else
			widget.setText( "pillAttemptLabel", "" );
		end
	else
		widget.setText( "pillAttemptLabel", "" );
	end
  else
	widget.setText( "pillAttemptLabel", "" );
  end
  
  return valid;
end
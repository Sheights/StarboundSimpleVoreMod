--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/util.lua"

chose_option = false;

function populateItemList()

	--Have to use Widget init here.
	local options = config.getParameter("textOptionList");
	
	if options ~= nil then
	
		local itemlist = "optionList"
		widget.clearListItems( itemlist )
	
		local optn = 1;
		for ok,ov in pairs( options ) do
			
			local itemid = widget.addListItem( itemlist );
			local pathtome = itemlist.."."..itemid;
			
			--widget.setData(String widgetName, Json data)
			--widget.registerMemberCallback(String widgetName, String callbackName, LuaFunction callback)
			local hasA = widget.getData( pathtome )
			local hasB = widget.getData( pathtome )
			local hasC = widget.getData( pathtome..".itemName" )
			local hasD = widget.getListSelected( itemlist )
			
			sb.logInfo( "Has pair "..tostring(pathtome).." "..tostring( ov.caption ).." "..tostring( hasD ).." "..tostring( hasC ) )
			
			widget.setText( pathtome..".itemName", ov.caption );
			widget.setImage( pathtome..".itemIcon", "/interface/quests/questreceiver.png" );
			widget.setText( pathtome..".count", tostring( optn ) );
			widget.setVisible( pathtome, true)
			
			--local selected = widget.getListSelected(self.itemList)
			--self.selectedPart = widget.getData(self.itemList.."."..selected)

			--widget.registerMemberCallback( pathtome, String callbackName, LuaFunction callback)
			
			--widget.setData( "optionList."..pathtome, {
			--	itemName = ov.caption
			--	,itemIcon = "/interface/quests/questreceiver.png"
			--	,count = optn
			--})	--Hmmmm
			optn = optn + 1;
		end
	end
	
end

function init( )
	
	targetId = config.getParameter("vsoOwnerID");
	playerId = config.getParameter("vsoInteractId")
	
	--Once loading the widget works, we can have a dialog tree with responses...
	--	Hm. Message response responses...

	--??
	
	--populateItemList()
end

function update(dt)

	--ok
	
	--Optional timeout if you don't decide quickly.
	--Can even change the background like a movie? odd...

	--populateItemList()
end

function uninit( )
	--Notify?
	if chose_option then
	
	else
		world.sendEntityMessage( targetId, "vsoDlgInteracted", "", playerId );
	end
end

function buttonClickEvent( buttonname, buttondata )

	--sb.logInfo( "buttonclicked? "..tostring( buttonname ).." "..tostring( buttondata ) );
	
	if world.entityExists( targetId ) then
	
		--buttonname -> value? (unsure what path needs to be)
		--local dat = widget.getData( "gui."..buttonname )
		
		--sb.logInfo( tostring( dat ) );
		--sb.logInfo( tostring( widget.getData( "gui.message" ) ) );
		
		--world.sendEntityMessage( targetId, "vsoDlgInteracted", dat.value, playerId );
	
		world.sendEntityMessage( targetId, "vsoDlgInteracted", buttondata, playerId );
		chose_option = true;
		pane.dismiss()
	else
		pane.dismiss()
	end
	
end

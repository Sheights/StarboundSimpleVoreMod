--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/util.lua"

function init( )
	
	targetId = config.getParameter("vsoOwnerID");
	playerId = config.getParameter("vsoInteractId")
	
	--widget.setText( "typeTabs.tabs.buy.tbCount", "1" )
	--items = config.getParameter("items");
	
	local haslblText = config.getParameter("lblText")
	if haslblText ~= nil  then
		widget.setText( "lblText", haslblText.value )
	end
	
	widget.setText( "lblText", "Noway" )
	widget.setText( "gui.lblText", "Nuhuh" )
		
	widget.setFontColor("lblText", '#FF0000')
  
end

function update(dt)

	if world.entityExists( targetId ) then
		
		--Hm...
		
	else
		pane.dismiss()
	end
end

function canvasClickEvent( position, button, isButtonDown )
  -- no mouse input, at least for now
  if isButtonDown then
	pane.dismiss()
  end
end

function canvasKeyEvent(key, isKeyDown)
  if isKeyDown then
	--hm...
  end
end

function buttonClickEvent( buttonname )
	
end

function uninit( )
	--Notify?
end
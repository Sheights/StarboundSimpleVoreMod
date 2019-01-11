require "/scripts/util.lua"

function init( )
	
	targetId = config.getParameter("vsoOwnerID");
	playerId = config.getParameter("vsoInteractId")
	
	--Good, but...
	
	--local hasmessage = config.getParameter("message")
	--if hasmessage ~= nil  then
	--	widget.setText( "message", hasmessage.value )
	--	--widget.setFontColor("lblText", '#FF0000')
	--end
	
	--widget.setData( "windowtitle", "{ \"title\":\"Neato\", \"subtitle\":\"Yahoo\" }" );
	--widget.setData( "windowtitle", { title:"Neato" } );
	
	--void widget.drawImageRect(String texName, RectF texCoords, RectF screenCoords, [Color color])
	--widget.setImage( "portrait", "/assets/interface/chatbubbles/koichi.png" )
	--widget.setImageScale( "portrait", 1.0 );
	
end

--function update(dt)

function buttonClickEvent( buttonname )

	if world.entityExists( targetId ) then
	
		--buttonname -> value? (unsure what path needs to be)
		--local dat = widget.getData( "gui."..buttonname )
		
		--sb.logInfo( tostring( dat ) );
		--sb.logInfo( tostring( widget.getData( "gui.message" ) ) );
		
		--world.sendEntityMessage( targetId, "vsoDlgInteracted", dat.value, playerId );
	
		world.sendEntityMessage( targetId, "vsoDlgInteracted", buttonname, playerId );
		
		pane.dismiss()
	else
		pane.dismiss()
	end
	
end

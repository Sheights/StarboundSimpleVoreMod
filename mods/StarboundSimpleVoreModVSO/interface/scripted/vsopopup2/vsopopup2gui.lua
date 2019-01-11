
function init( )

	targetId = config.getParameter("vsoOwnerID");
	playerId = config.getParameter("vsoInteractId")
	
	saythis = config.getParameter("message")
	
	--[[
	
	"interactCustomQuestion":{
		"config" : "/interface/scripted/vsopopup2/vsopopup2.config",
		"paneLayoutOverride"  : {
		  "windowtitle" : {
			"title" : "Question from Tally",
			"icon" : {
			  "file" : "/interface/statuses/health.png"
			}
		  }
		}
	},
	
	self.customInteractPanel = "interactCustomQuestion"
	self.customInteractDataCallback = function( d ) 
		--You can change stuff here.
		if math.random() < 0.5 then
			d.message = "Hello and this would be a question if I had one."
		else
			d.message = "Hi?"
		end
	end
	
	]]--
	
	--"onShowSound": [
	--	"/sfx/objects/screen2.ogg"
	--],
	--widget.playSound(String audio, [int loops = 0], [float volume = 1.0f])
	
	--Based on config, setup this question panel appropriately
	--IE, create the necessary response buttons...
	
	--A 9-scale frame system? Hm.
		
	--Widget elements must ALREADY be defined. AKA, LT, L, LB, B, RB, R, RT T, C elements for the 9scale.
	--	And any buttons we want to use (max of 5? with icons?)
	
	--Vec2I widget.getPosition(String widgetName)
	--void widget.setPosition(String widgetName, Vec2I position)
	--Vec2I widget.getSize(String widgetName)
	--void widget.setSize(String widgetName, Vec2I size)
	--widget.setText(String widgetName, String text)
	
	
	--sb.logInfo( "pane" )
	--for k,v in pairs( pane ) do
	--	sb.logInfo( k .." = "..tostring(v) )
	--end
	
	--script
	--pane
	--coroutine
	--world
	--player
	--config
		
	--[[
	local position = entity.position()
	  world.spawnStagehand(position, "questmanager", {
		  uniqueId = arc.questArc.stagehandUniqueId,
		  quest = {
			  arc = storeQuestArcDescriptor(arc.questArc),
			  participants = arc.participants
			},
		  plugins = arc.managerPlugins
		})
	  return true
	]]--
	  
	--Get images so we can uh. Add directives? (colored dialog)
	
	local bgw = 128;	--Maximum?
	local bgh = 128;
	
	local w = bgw-20;
	local h = bgh-20;	--Calculate height from text wrap
	
	widget.setText( "message", saythis );
	local wasa = widget.getSize( "message" )	--Gets the width of the text! nice
	
	local exas = (bgw-10-10 - wasa[1])
	if wasa[2] < 10 then
		wasa[2] = 10;
	end
		
	local xMin = 10 + exas/2;
	local yMin = 10;
	local yMax = yMin + wasa[2];	--Approxioms
	local xMax = xMin + wasa[1];	--bgw-10;
	local ygap = 
	
	widget.setPosition( "message", { xMin, yMax+5 } )
	
	--if title then widget.setText("lblTitle", title) end
	--if subtitle then widget.setText("lblSubtitle", "^gray;" .. subtitle) end
	--widget.setImage("imgTitleIcon", path)
	
	--widget.getPosition("gui")
	--widget.setPosition("gui", {10,10})
		
	--local whatsit = root.imageSize( icon );	--obviously we know what this is.
	
	widget.setPosition( "frameLT", {xMin-10, yMax })
	widget.setPosition( "frameTR", {xMax, yMax })
	widget.setPosition( "frameBL", {xMin-10, yMin })
	widget.setPosition( "frameBR", {xMax, yMin })
	widget.setSize( "frameLT", {10,10} )
	widget.setSize( "frameTR", {10,10} )
	widget.setSize( "frameBL", {10,10} )
	widget.setSize( "frameBR", {10,10} )
	
	widget.setPosition( "frameC", {xMin, yMin+5 })
	widget.setSize( "frameC", {xMax-xMin,yMax-yMin} )
	
	widget.setPosition( "frameL", {xMin-10, yMax-10 })
	widget.setSize( "frameL", {10,yMax-yMin} )
	widget.setPosition( "frameR", {xMax, yMax-10 })
	widget.setSize( "frameR", {10,yMax-yMin} )
	widget.setPosition( "frameT", {xMin, yMax })
	widget.setSize( "frameT", {xMax-xMin,10} )
	widget.setPosition( "frameB", {xMin, yMin })
	widget.setSize( "frameB", {xMax-xMin,10} )
	
	--widget.setPosition( "framePoint", {0-4, 0-4 })
	--widget.setPosition( "framePointL", {0-4, 0-4 })
	--widget.setPosition( "framePointR", {0-4, 0-4 })
	widget.setVisible( "framePoint", false)
	widget.setVisible( "framePointL", false)
	widget.setVisible( "framePointR", false)
	
	--message
	
	acted = 0;
	world.sendEntityMessage( targetId, "vsoPanelInit", targetId, playerId )
	
end

function update(dt)

	if world.entityExists( targetId ) then
	
		--do stuff
	
	else
		pane.dismiss()
	end
end

function uninit( )
	if acted == 0 then
		if world.entityExists( targetId ) then
			world.sendEntityMessage( targetId, "vsoPanelClosed", targetId, playerId )
		end
	end
end

--callbacks
function btnClicked( arg1 )
	sb.logInfo( arg1 );
	acted = 1;
	world.sendEntityMessage( targetId, "vsoPanelReponse", targetId, 0 )
	pane.dismiss()
end

function btnYes( arg1 )
	acted = 1;
	world.sendEntityMessage( targetId, "vsoPanelReponse", targetId, 1 )
	pane.dismiss()
end
--TODO
--	Make NPC interaction work right (for fake E/interact)
--	Determine current item/object selected?
--		Would like it to be easier to "close" a vehicle with item use?
--



function vsoSimulatePlayerDistanceSquared( a, b )
	local dx = b[1] - a[1];
	local dy = b[2] - a[2];
	return dx*dx + dy*dy;
end

function vsoSimulatePlayerListBestDm( objlist, cenpos )

	local objid = nil;
	local lowestdist = 1000000;
	--local cenpos = mcontroller.position();
	for k,v in pairs( objlist ) do
		local objpos = world.entityPosition( v )
		if objpos ~= nil then
			local hitpos = world.lineCollision( cenpos, objpos );
			if hitpos ~= nil then
				--Hm... well. what? huh???
				local distc = vsoSimulatePlayerDistanceSquared( hitpos, cenpos )
				if distc < lowestdist then
					objid = v;
					lowestdist = distc;
				end
			end
		end
	end
	return objid;
end

function vsoSimulatePlayerComputeRayBounds( cenpos, aimposition )

	local minpos = { math.min(cenpos[1], aimposition[1]), math.min(cenpos[2], aimposition[2]) } 
	local maxpos = { math.max(cenpos[1], aimposition[1]), math.max(cenpos[2], aimposition[2]) } 
	
	return { minpos[1], minpos[2], maxpos[1], maxpos[2] }

end

function vsoSimulatePlayerTargetRadiusCheck( targetPosition, cursorPosition, radius )
  --if target and world.entityExists( target ) then
    local pos = mcontroller.position()
    --local targetPosition = --world.entityPosition( target )
	--world.magnitude(pos, targetPosition)
    if world.magnitude(pos, targetPosition) <= radius and not world.lineCollision(pos, targetPosition) then
      --local cursorPosition = activeItem.ownerAimPosition()
      return world.magnitude( targetPosition, cursorPosition ) < radius;
    end
  --end

  return false
end

function vsoSimulatePlayerTargetRadiusClamp( aimPosition, radius )
	local retpos = aimPosition;
    local pos = mcontroller.position()
	local delmag = world.magnitude(pos, aimPosition);
	if delmag > radius then
		local dx = aimPosition[1] - pos[1];
		local dy = aimPosition[2] - pos[2];
		retpos = { pos[1] + radius * dx/delmag, pos[2] + radius * dy/delmag }
	end
	return retpos;
end

function vsoSimulateWorldMetric( cenpos, targetpos, entityid, offx, offy )

	if entityid ~= nil then
	
		--fire a ray? closest hitpoint wins?
		--local hitpos = world.lineCollision( cenpos, targetpos );
	
		local pos = world.entityPosition( entityid );	--this isnt right
		
		--okay but no. we want the CENTER of the thing... bounding box?
		
		local dx = targetpos[1] - (pos[1] + offx);
		local dy = targetpos[2] - (pos[2] + offy);
		local dm = math.sqrt( dx*dx + dy*dy );
		
		return dm;
		
	else
		return 10000000.0
	end
end

function vsoSimulatePlayerBoundsAhead( dx, yspace )

	local bounds = mcontroller.collisionBoundBox();--rect.translate(mcontroller.collisionBoundBox(), mcontroller.position())
	bounds[2] = bounds[2] - yspace
	bounds[4] = bounds[4] + yspace
	if dx > 0.0 then
		bounds[1] = bounds[3] - 0.125	--important?
		bounds[3] = bounds[3] + dx
	else
		bounds[3] = bounds[1] + 0.125	--important?
		bounds[1] = bounds[1] + dx
	end
	return bounds;
end

function vsoSimulatePlayerQueryFirstDoorAhead( deltax, ygrow )

	local bounds = vsoSimulatePlayerBoundsAhead( deltax, ygrow );
	
	local capability = "closedDoor";
	local action = "openDoor";
	if world.rectTileCollision(bounds, {"Dynamic"}) then
		capability = "closedDoor"
		action = "openDoor";
	else
		capability = "openDoor"
		action = "closeDoor";
	end
		
	local doorIds = world.entityQuery(rect.ll(bounds), rect.ur(bounds), { includedTypes = {"object"}, callScript = "hasCapability", callScriptArgs = { capability } })
	
	if #doorIds > 0 then
		for _, doorId in pairs(doorIds) do
			return { doorId, action }
		end
	end
	
	return nil

end

function vsoSimulatePlayerToggleDoorsAhead( doorid, dooraction )--, playerid )-- deltax, ygrow )

	--local result = vsoSimulatePlayerQueryFirstDoorAhead( deltax, ygrow );
	if doorid ~= nil then
		world.sendEntityMessage( doorid, dooraction )
	end
	return result;
	--[[
	local bounds = vsoSimulatePlayerBoundsAhead( deltax, ygrow );
	
	local capability = "closedDoor";
	local action = "openDoor";
	if world.rectTileCollision(bounds, {"Dynamic"}) then
		capability = "closedDoor"
		action = "openDoor";
	else
		capability = "openDoor"
		action = "closeDoor";
	end
		
	local firstdoorid = nil;
	local togglecount = 0;
	
	local doorIds = world.entityQuery(rect.ll(bounds), rect.ur(bounds), { includedTypes = {"object"}, callScript = "hasCapability", callScriptArgs = { capability } })
	if #doorIds > 0 then
		for _, doorId in pairs(doorIds) do
			world.sendEntityMessage(doorId, action)
			if firstdoorid == nil then
				firstdoorid = doorId;
			end
			togglecount = togglecount + 1;
		end
	end
	
	return firstdoorid
	]]--
end

function vsoSimulatePlayerQueryNPC( targetposition, radius )

	local npcid = nil;
	
	local npclist = world.npcQuery( targetposition, radius, { order="nearest" } );
	if #npclist > 0 then
	
		--world.platformerPathStart()
		--world.findPlatformerPath()
	
		--root.tenantConfig(String tenantName)
		--root.npcConfig(String npcType)
		
		npcid = vsoSimulatePlayerListBestDm( npclist, targetposition );--mcontroller.position(); );
		
		--for k,v in pairs( npclist ) do
		--	local npcpos = world.entityPosition( v )
		--	if npcpos ~= nil then
		--		if world.lineCollision( mcontroller.position(), npcpos ) then
		--			
		--			npcid = v;
		--			return
		--		end
		--	end
		--end
	end
	
	return npcid;
end


function vsoSimulatePlayerNPCInteract( npcid, playerid )--targetposition, radius, playerid )

	--local npcid = vsoSimulatePlayerQueryNPC( targetposition, radius );
	local finalnpcid = nil;
	
	if npcid ~= nil then
	
		world.sendEntityMessage( npcid, "vsoPlayerInteract", {}, playerid );
		
		--sb.logInfo( "attempting NPC interaction "..tostring( npcid ) );
		
		--player.interact( "Message", data, npcid )
		--world.sendEntityMessage( playerid, "vsoForceInteract", "Message", 
		--	{
		--		messageType = "interaction"	--didnt crash... hm...
		--		,messageArgs = { { sourceId=playerid } }--sourceId = playerid 
		--	}, npcid );
		
		--	
			--None
			--OpenContainer
			--SitDown
			--OpenCraftingInterface
			--OpenSongbookInterface
			--OpenNpcCraftingInterface
			--OpenMerchantInterface
			--OpenAiInterface
			--OpenTeleportDialog
			--ShowPopup
			--ScriptPane
			--Message
		--
		--world.sendEntityMessage(self.target, "notify", {type = "arresting", sourceId = activeItem.ownerEntityId()})
		
		--local promise = world.sendEntityMessage( playerid, questId..".participantEvent", entity.uniqueId(), "interaction" )
		--notify ?
		
        --[[
		
		self.questParticipant:fireEvent("interaction", args.sourceId)
		  
		function QuestParticipant:fireEvent(eventName, ...)
		  local uniqueId = entity.uniqueId()
		  for stagehand, role in pairs(self.data.roles) do
			for player, questId in pairs(role.players) do
			  if role.participateIn[questId] then
				local message = questId..".participantEvent"
				self.outbox:sendMessage(player, message, uniqueId, eventName, ...)
			  end
			end
		  end
		end
		
		--self.outbox:sendMessage(player, questId..".participantEvent", entity.uniqueId(), "interaction", ...)
		self.outbox:sendMessage(player, message, uniqueId, eventName, ...)
					
					
		function Outbox:sendMessage(recipient, message, ...)
		  self:sendMessageWithOptions({}, recipient, message, ...)
		end

		
		--sendMessageWithOptions({}, player, questId..".participantEvent", entity.uniqueId(), "interaction", ...)
		function Outbox:sendMessageWithOptions(options, recipient, message, ...)
		  local messageData = {
			  options = options,
			  recipient = recipient,
			  message = message,
			  args = {...}
			}
		  if not self:trySend(messageData) then
			self:postpone(messageData)
		  end
		end
				
		--trySend({
			  options = {},
			  recipient = player,
			  message = questId..".participantEvent",
			  args = { entity.uniqueId(), "interaction" }
		})
		function Outbox:trySend(messageData)
		  if self.contactList:isEntityAvailable(messageData.recipient) then
			local promise = world.sendEntityMessage(messageData.recipient, messageData.message, table.unpack(messageData.args))
			if not messageData.options.unreliable then
			  messageData.response = promise
			  self.sent[#self.sent+1] = messageData
			end
			self:logMessage(messageData, "sent")
			return true
		  end
		  return false
		end
		
		local promise = world.sendEntityMessage( player, questId..".participantEvent", entity.uniqueId(), "interaction" )
		]]--

		--local promise = world.sendEntityMessage( messageData.recipient, messageData.message, table.unpack(messageData.args) )
		
		--world.sendEntityMessage( npcid, "interaction", playerid ); --nothing...
	
		--I really wanted this to work... maybe with more work?
		--world.sendEntityMessage( playerid, "vsoForceInteract", "Message", {
		--	messageType = "interaction"	--didnt crash... hm...
		--	,messageArgs = { { sourceId=playerid } }--sourceId = playerid 
		--}, npcid );
		
		--player.interact( "Message", { messageArgs = {0}, messageType="EntityInteract" }, targetEntityId )
		
        --  messageType = action.messageType,
        --  messageArgs = args
		  
		--messageData.recipient
		--messageData.options
		
		--OKAY! there is a OBJECT (contract thingy) that calls the NPC to interact/say at YOU
		--so how do we deal with that?
		--	world.callScriptedEntity(primary, "tenant.canDeliverRent") ???
		--
		--	self.questParticipant:fireEvent("interaction", args.sourceId)
		--
		--	require "/scripts/quest/participant.lua"
		--
		--	
		--
		--Colony deed:
		--[[
			function onInteraction(args)
			  self.questParticipant:fireEvent("interaction", args.sourceId)

			  if isOccupied() then
				if isRentDue() then
				  local primary = primaryTenant()
				  callTenantsHome("rent")
				  if not self.npcsDeliverRent or not primary or not world.callScriptedEntity(primary, "tenant.canDeliverRent") then
					world.spawnTreasure(self.position, getRent().pool, getRentLevel())
					self.rentTimer:reset()
				  end
				else
				  callTenantsHome("beacon")
				end
				animator.setAnimationState("deedState", "beacon")

			  else
				scanVacantArea()
			  end
			end
		]]--
		--Somehow this is really hard.
		--We have the playerid, the npcid, and just need them to trigger a interaction.
		--BUT the player.interact only has a FIXED LIST of things it can do:
		--	
			--None
			--OpenContainer
			--SitDown
			--OpenCraftingInterface
			--OpenSongbookInterface
			--OpenNpcCraftingInterface
			--OpenMerchantInterface
			--OpenAiInterface
			--OpenTeleportDialog
			--ShowPopup
			--ScriptPane
			--Message
		--
		
		--world.sendEntityMessage( playerid, "vsoForceInteract", "None", {sourceId = playerid}, npcid );
		
		--
		
		
		--local configjson = { sourceId = playerid }	--, targetId = npcid
		--{ messageArgs = {0}, messageType="EntityInteract" }; --
		--world.callScriptedEntity( npcid, "interact", {sourceId = playerid} )
		
		--world.sendEntityMessage( playerid, "vsoForceInteract", "interact", configjson, npcid );
		
		--player.interact( "Message", { messageArgs = {0}, messageType="EntityInteract" }, targetEntityId )
		
		--world.sendEntityMessage( npcid, "vsoplayerinteract", configjson, playerid )	--requires a patch to npc base.
		
		--Huh. for SOME REASON npc's dont initialize with the base thing... "vsoplayerinteract"
		--	function handleInteract(args) (merchants)
		--	function onInteraction(args)  (objects? vehicles?)
		--	world.sendEntityMessage(uniqueId, "recruit.interactBehavior", { sourceId = entity.id() })   recruit specific? in player scrupt?
		
		--world.callScriptedEntity( npcid, "interact", configjson );
		
		--world.callScriptedEntity( npcid, "onInteraction", configjson );
		
		--player.interact( type, config, target )
		
		
		--world.sendEntityMessage( playerid, "vsoForceInteract", "Message", configjson, npcid ); --Crashes system, messageArgs, etc...
				
		finalnpcid = { npcid, "npc" }
		
	end
	
	--[[
	local npcid = nil;
	
	local npclist = world.npcQuery( targetposition, radius, { order="nearest" } );
	if #npclist > 0 then
	
		--world.platformerPathStart()
		--world.findPlatformerPath()
	
		--root.tenantConfig(String tenantName)
		--root.npcConfig(String npcType)
		
		npcid = npclist[1];
		local configjson = { sourceId = playerid }	--, targetId = npcid
		sb.logInfo( "attempting NPC interaction "..tostring( npcid ) );
		world.sendEntityMessage( npcid, "vsoplayerinteract", configjson )	--requires a patch to npc base.
		
		--the heck is this crap.
		--function setInteracted(args)
		--	self.quest:fireEvent("interaction", args.sourceId)
		--	self.interacted = true
		--	self.board:setEntity("interactionSource", args.sourceId)
		--end
		
		--WELL APPARENTLY, some NPC's have "scriptConfig" with a "behaviour" defined.
		--This apparently OVERRIDES existing scripts, so that you must now patch ALL of these:
		--"scriptConfig" : {
		--	"behavior" : "villager",
		--\behaviors\npc\*   scripts-
		--
		
		--It is unknown why the base behaviour is removed from scriptConfig entities.
		
		
		--local npctype = world.npcType( npcid );
		--local npcconfig = root.npcConfig( npctype );	--This tree's UP with baseType... all the way back to base...
		--local npcbasetype = "";
		--local npcbasetype = npcconfig.baseType or npctype;
		
				
		--sb.logInfo( "attempting NPC interaction "..tostring( npcid ).." "..npctype.." "..npcbasetype );
		
		
		--crewmembermechanic crewmember
		--blah villager
		
		--https://starbounder.org/Modding:Lua/Tables/World
		
		--Not sure about this one (but a local interact makes sense?)
		--world.callScriptedEntity( npcid, "interact", configjson )	--Doesnt listen to you are a player
		
		--npc.nodes ??
		--world.sendEntityMessage( npclist[1], "notify", "action", "inspectEntity", { target = playerid } );
		--world.sendEntityMessage( npclist[1], "notify", "action", "inspectEntity", { target = playerid } );
		--world.sendEntityMessage( npclist[1], "notify", "whatever" );
		--world.sendEntityMessage( npclist[1], "suicide" )

		--Huh... "interact" doesnt work on crew members? huh...
		
		--"vsoForceInteract" interactionType, config, targetid (huh...)
		--world.sendEntityMessage( playerid, "vsoCallScriptedEntity"
		--	, npclist[1]
		--	,"interact"
		--	, { source = { playerid }, sourceId = playerid } 
		--)	--Doesnt listen to you are a player
		
		--self._message_args_default[1] = 3
		--self._message_args_default[2] = playerid
		--self._message_args_default[3] = npclist[1] 
		--self._message_args_default[4] = "interact"
		
		--Well, nope.
		--world.sendEntityMessage( playerid, "vsoForceInteract", "Message", {
		--	--messageArgs = { npclist[1], "suicide" }--self._message_args_default--{ playerid, "interact", {} }
		--	--,messageType = "EntityMessage"	--"EntityInteract"	--messagetype--jobject( "interact" )
		--	messageArgs = { { source = { playerid }, sourceId = playerid, targetId = npclist[1] } }--self._message_args_default--{ playerid, "interact", {} }
		--	,messageType = "EntityInteract"	--"EntityInteract"	--messagetype--jobject( "interact" )
		--}, npclist[1] )
		
		--player.interact( "Message", { messageArgs = {0}, messageType="EntityInteract" }, targetEntityId )
		
		--LOL this is funny. And useful!
		--world.sendEntityMessage( npclist[1], "suicide" )
				
				
		--messageargs[1] = jarray();--playerid
		
		--local messagetype = jarray();	--PlayerInteract ? EntityInteract ? onInteraction ? interact? interactAction? interactData? questInteract? callOtherHandScript?
		--jresize( messagetype, 1 );
		
		--sendEntityMessage( entityId, messageType, ... )
		--MainInterface:handleInteractAction -> 
		
		--Improper conversion to JsonArray from object
		
		--world.sendEntityMessage( playerid, "vsoForceInteract", "None", {}, npclist[1] )
		
		--world.sendEntityMessage( playerid, "vsoForceInteract", "None", { sourceId = playerid }, npclist[1] )
		
		--world.sendEntityMessage( playerid, "vsoForceInteract", "Message", { messageArgs = {} }, npclist[1] )
		
		--INTERACT with them???
		--sb.logInfo( "attempting NPC interaction "..tostring( npclist[1] ) );
		
		--HIGHLY SUSPECT (also its synchronous...)
		--world.callScriptedEntity( npclist[1], "interact", {sourceId = entity.id()} )
		
		--world.sendEntityMessage( npclist[1], "interact", { sourceId = entity.id() } );
		
		--world.sendEntityMessage( npclist[1], "notify", {
		--function onInteraction(interactSource)
		--world.sendEntityMessage(interactSource.sourceId, "deployMech")
		--end
	end
	]]--
	return finalnpcid;
end

function vsoSimulatePlayerQueryObject( aimposition, radius )

	local objid = nil;
	
	local objlist = world.objectQuery( aimposition, radius, { order="nearest" } );
	if #objlist > 0 then
	
		objid = vsoSimulatePlayerListBestDm( objlist, aimposition );
		
	end
	
	return objid;

end

function vsoSimulatePlayerObjectInteract( objid, playerid )--aimposition, radius, playerid )

	--world.entityType(EntityId entityId)
	--world.entityTypeName(EntityId entityId)
	--local objid = vsoSimulatePlayerQueryObject( aimposition, radius );
	local finalobjid = nil;
	
	if objid ~= nil then
	
		--How do we KNOW something about this object... without crashing?
		--Some objects are SPECIAL interfaces (obviously)
		--get object type,
		--get object CONFIG
		--Look for things like:
		--	"interactAction"
		--	"interactData"
		--	"inactiveInteractAction"
		--	"inactiveInteractData"
		
		local typeofobject = world.entityTypeName( objid )
		local objobjectType = world.getObjectParameter( objid, "objectType", nil )
		local objinteractAction = world.getObjectParameter( objid, "interactAction", nil )
		
		--sb.logInfo( "FAKE INTERACT: " .. tostring(typeofobject).." act:"..tostring( objinteractAction ).." type:"..tostring(objobjectType).." "..tostring( entity.id() ) );
		
		--Easy check for a container... (hm)
		if objobjectType == "loungeable" and objinteractAction == nil then	--world.containerClose( objid ) then	objinteractAction must BE something.
		
			--No good. just a "chair" for what its worth.
		
		elseif objobjectType == "container" then	--world.containerClose( objid ) then
		
			--Well, some things dont work here... because SOME containers are not... really containers?
			
			--Object MUST be in a line of sight to player... as an extra check.
			world.sendEntityMessage( playerid, "vsoForceInteract", "OpenContainer", { sourceId = playerid }, objid )
			
			return { objid, "container" };
		else
				
			--Worry about DOORS please...
			
			--world.objectAt(Vec2I tilePosition)
			local doorstoopen= world.entityQuery( world.entityPosition( objid ), 0.125, { boundMode="position", includedTypes = {"object"}, callScript = "hasCapability", callScriptArgs = { "closedDoor" } } )--capability = "closedDoor" action = "openDoor";
			local doorstoclose = world.entityQuery( world.entityPosition( objid ), 0.125, { boundMode="position", includedTypes = {"object"}, callScript = "hasCapability", callScriptArgs = { "openDoor" } } )--capability = "openDoor" action = "closeDoor";
			
			--we know the ID we want to check. so it HAS to be in those lists.
			
			--sb.logInfo( "Door check "..tostring( #doors1 ).." "..tostring( #doors2 ) );
			
			for dk, dv in pairs( doorstoopen ) do
				if dv == objid then
					--action = "openDoor";
					world.sendEntityMessage( objid, "openDoor" )
					return { objid, "door", "openDoor" };
				end
			end
			for dk, dv in pairs( doorstoclose ) do
				if dv == objid then
					--action = "closeDoor";
					world.sendEntityMessage( objid, "closeDoor" )
					return { objid, "door", "openDoor" };
				end
			end
			
			--object woodendoor

			--local whatisit = world.entityType( objid ) == "object"
			--local nameofobject = world.entityName( objid )	--should be same as typeofobject...
			--local descofobject = world.entityDescription( objid )
			
			local configjson = { source = { playerid }, sourceId = playerid, targetId = objid }
				
			local objinteractData = world.getObjectParameter( objid, "interactData", nil )
			if objinteractData ~= nil then
				--objinteractData might be a PATH to a CONFIG... OR a json object. HUH.
				if type( objinteractData ) == type( "" ) then
					local newconfigjson = root.assetJson( objinteractData );
					if newconfigjson ~= nil then
						configjson = newconfigjson
					end
				else
					configjson = objinteractData;
				end
				configjson.sourceId = playerid;
				configjson.source = { playerid };
				configjson.targetId = objid
			end
			
			--is object active? ( objinteractAction vs objinactiveInteractAction )
			if objinteractAction ~= nil then
			
				--this covers a NUMBER of cases: "OpenCraftingInterface", "OpenSongbookInterface", "OpenMerchantInterface", "OpenAiInterface", "OpenTeleportDialog"
				
				--We are UNSURE about these cases: "ShowPopup" "ScriptPane" "Message" "SitDown" "None"
					
				world.sendEntityMessage( playerid, "vsoForceInteract", objinteractAction, configjson, objid );
				
				return { objid, "interactable" };
				
				--Also, some objects have a "inactive" mode so, what the heck:
				
				--local objinactiveInteractAction = world.getObjectParameter( objid, "inactiveInteractAction", "" )
				--local objinactiveInteractData = world.getObjectParameter( objid, "inactiveInteractData", "" )
				
				--sb.logInfo( objinactiveInteractAction );
				--sb.logInfo( objinactiveInteractData );
			else
			
				--Well, its NOT scripted. Now what?
				--Objects can have:
				--	"offeredQuests" : []
				--	"chatOptions" : []
				--	object.setOfferedQuests({})
				local objchatOptions = world.getObjectParameter( objid, "chatOptions", nil )
				local objofferedQuests = world.getObjectParameter( objid, "offeredQuests", nil )
				
				if objofferedQuests ~= nil then
				
					--player.hasQuest(String questId)
					--player.hasCompletedQuest(String questId)
					
					--ATTEMPT to offer player a quest?hmmm... player.startQuest("bountyassignment")

					--GENERATE QUEST ACTION ( hm! possible... from companions\recruitable.lua well maybe not. )
					--[[
					  local action = config.getParameter("crew.recruitInteractAction")

						"recruitInteractAction" : {
						"messageType" : "recruits.offerRecruit",
						
							function offerRecruit(uniqueId, position, recruitInfo, entityId)
							  return recruitImpl(uniqueId, position, recruitInfo, entityId, "/interface/confirmation/recruitconfirmation.config", {})
							  
																		  
								local function recruitImpl(uniqueId, position, recruitInfo, entityId, dialogConfigPath, price)
								  local uuid = recruitInfo.podUuid or sb.makeUuid()
								  if not playerHasItems(price) or not checkCrewLimits(uuid) then
									world.sendEntityMessage(uniqueId, "recruit.interactBehavior", { sourceId = entity.id() })
									return false
								  end

								  local recruit = Recruit.new(uuid, recruitInfo)
								  local dialogConfig = createConfirmationDialog(dialogConfigPath, recruit)
								  dialogConfig.sourceEntityId = entityId
								  if recruit.portrait then
									dialogConfig.images.portrait = recruit.portrait
								  end

								  promises:add(player.confirm(dialogConfig), function (choice)
									  if choice and playerHasItems(price) then
										promises:add(world.sendEntityMessage(uniqueId, "recruit.confirmRecruitment", recruitSpawner.ownerUuid, uuid, onOwnShip()), function (success)
											if success then
											  consumeItems(price)

											  recruitSpawner:addCrew(uuid, recruitInfo)
											end
										  end)
									  else
										world.sendEntityMessage(uniqueId, "recruit.declineRecruitment", recruitSpawner.ownerUuid)
									  end
									end)
								end
							end
							
						"messageArgs" : []
						},

					  local args = {
						  entity.uniqueId(),
						  entity.position(),
						  recruitable.generateRecruitInfo(),
						  entity.id()
						}
					  util.appendLists(args, action.messageArgs or {})

					  return {
						  "Message",
						  {
							  messageType = action.messageType,
							  messageArgs = args
							}
						}
					]]--

					--configjson.?
					--world.sendEntityMessage( playerid, "vsoForceInteract", "PlayerInteract", configjson, objid );
					sb.logInfo( "has quest offerings "..tostring( objofferedQuests ) );
				end
				
				if objchatOptions ~= nil then
					--configjson.?
					world.sendEntityMessage( playerid, "vsoForceInteract", "None", configjson, objid );
					sb.logInfo( "has chat options "..tostring( objchatOptions ) );
				end
				
				
				--Not sure about this one (only interacting IN WORLD?)
				--we also should NOT call scripted entity if we can avoid it...
				--MUST find some way to avoid this!!! or at least MOVE it to a better context... (player?)
				world.callScriptedEntity( objid, "onInteraction", configjson )	--No good for some things
				
				finalobjid = { objid, "default" };
				
				--Huh.
				
				--sourceId
				--sourcePosition
				--interact
				--interactPosition
				--sourceEntityId
				--type
				--
				--onInteraction ??
				
				--configjson.interact = objid;
				--world.sendEntityMessage( playerid, "vsoForceInteract", "None", configjson, objid );
				
				--configjson.messageArgs = { playerid }
				--configjson.messageType = "EntityInteract"
				--world.sendEntityMessage( playerid, "vsoForceInteract", "Message", configjson, objid );
				--sb.logInfo( typeofobject.." objectid: "..tostring( objid ) );
				
				--world.sendEntityMessage( objid, "trigger" )	--only with some boss parts :C
				--world.sendEntityMessage(playerId, "playAltMusic", self.music, config.getParameter("fadeInTime"))
				--world.sendEntityMessage(playerId, "playAltMusic", jarray(), config.getParameter("startFadeOutTime"))
				--world.sendEntityMessage(entity.id(), "playCinematic", config.getParameter("midpointCinematic"))
				--world.sendEntityMessage(quest.questArcDescriptor().stagehandUniqueId, "interactObject", quest.questId(), entityId) --not a built in... what IS a stagehand...

			end
		end
	end

	return finalobjid;
end

function vsoSimulatePlayerInteraction( playerid, aimposition, usefacingdir, radius )
	--vsoSimulatePlayerInteraction( self.vsoSpawnVehicleOwnerEntityId, self.last_aim_position, 2.5, vsoDirection() )
	
	--Anyway we can get ACTUALLY what is selected/highlighted? Hm...
	--	not sure.
	
	
	--[[
	
	Just because something HAS a interactAction (like a light) doesnt mean the PLAYER can trigger it (player needs to wire a switch)
	So how do we differentiate those?
	
	Still have problems with interact with NPC's
	
	
	]]--
		
	--We attempt to simulate a player's interaction (to mimic a player as best as possible)
	--Additionally, each TYPE of interaction needs to be broken out simply, so you can construct different priority interacts.
	--Since there is a default order in starbound, we start there.
	--though, it DOES SEEM like "distance to center of cursor" takes priority...
	--it is hard to determine the "highlighted" object so.
	
	--Also, this is a BIT more complicated since, we dont HAVE to face the target position...
	
	--Well, basically, we take the CLOSEST object to the aim position and do that.
	local aimpositionclamped = vsoSimulatePlayerTargetRadiusClamp( aimposition, radius );
	local aimpositiongrid = { math.floor( aimpositionclamped[1] ), math.floor( aimpositionclamped[2] ) } 
	local aimpositiongriddistance = world.magnitude( aimpositionclamped, { aimpositiongrid[1] + 0.5, aimpositiongrid[2] + 0.5 }  );
	
	local bounds = vsoSimulatePlayerComputeRayBounds( mcontroller.position(), aimpositionclamped );
	
	local directlist = world.entityLineQuery( rect.ll(bounds), rect.ur(bounds), { includedTypes = { "object", "npc", "monster" }, boundMode="collisionarea", order="nearest" } )	--ignoring players...
	
	if #directlist > 0 then
	
		--Well... interesting. nope. world.collisionBlocksAlongLine(Vec2F startPoint, Vec2F endPoint, [CollisionSet collisionKinds], [int maxReturnCount])
		--How to do a collisionarea test. We just need it for ONE entity at a time...
		--Bah!
		--Also, this list is NOT REALLY SORTED because it lets SOME things BEHIND you pass... so thats weird.
		
		--Well, do it again with JUST blocks for the first cut (since we can kinda get the intersection of our ray and blocks THAT way first...)
		--Unsure how to equate this with npc or dynamic collisions...
		
		local targetedobject = world.objectAt( aimpositiongrid );
		
		local lowestdistance = 1000000;
		local lowsetbestid = nil;
		local newdirectlist = {};
		for k,v in pairs(directlist) do
		
			local etype = world.entityType(v)
			local especific = world.entityTypeName(v)
			
			if etype == "object" then
				--check ray intersection distance to aimpositionclamped with collisionarea
				--world.getObjectParameter(EntityId entityId, String parameterName, [Json defaultValue])
				--Objects ONLY have "collisionSpaces" and other collision ideas??? Hm.
				
				--EntityId world.objectAt(Vec2I tilePosition) with a 
				--world.collisionBlocksAlongLine(Vec2F startPoint, Vec2F endPoint, [CollisionSet collisionKinds], [int maxReturnCount])
				
				--List<Vec2I> world.objectSpaces(EntityId entityId)
				--Returns a list of tile positions that the specified object occupies, or nil if the entity is not an object. 
				
				--world.pointCollision(Vec2F point, [CollisionSet collisionKinds])
				if v == targetedobject then
					if aimpositiongriddistance < lowestdistance then
						lowsetbestid = v;
						lowestdistance = aimpositiongriddistance	--Only one object per tile so thats simple... distance to tile CENTER?
					end
				else
					--distance to object (occupied tiles) is a factor... (FIND A BETTER WAY)
					local allspaces = world.objectSpaces( v );
					local objectdistance = 10000;
					if allspaces ~= nil then
						for _, space in pairs( allspaces ) do
							local tiledist = world.magnitude( { space[1]+0.5, space[2]+0.5 }, aimpositionclamped )
							if tiledist < lowestdistance then
								lowsetbestid = v;
								lowestdistance = tiledist	--Only one object per tile so thats simple... distance to tile CENTER?
							end
						end
					else
					
						sb.logInfo( "Object has no spaces: "..tostring( v ) );
					
					end
				end
				
			elseif etype == "npc" then
				--check ray intersection distance to aimpositionclamped with collisionarea
				--how the hell do we get the collision poly???
				
				--Well if we do this WITH and WITHOUT...
				--	world.entityQuery(Vec2F position, Variant<Vec2F, float> positionOrRadius, [Json options])	withoutEntityId
				--Then.. the difference is... uh...
				--
				local npcdist = world.magnitude( world.entityPosition(v), aimpositionclamped );
				if npcdist < lowestdistance then
					lowsetbestid = v;
					lowestdistance = npcdist
				end
				
				--world.polyContains(PolyF poly, Vec2F position)
				--world.resolvePolyCollision(PolyF poly, Vec2F position, float maximumCorrection, [CollisionSet collisionKinds])
				
				--table.insert( newdirectlist, v );	--But a NPC is a bit more complicated. Distance to CENTER?
			elseif etype == "monster" then
			
				local monsterdistance = world.magnitude( world.entityPosition(v), aimpositionclamped );
				if monsterdistance < lowestdistance then
					lowsetbestid = v;
					lowestdistance = monsterdistance
				end
				
			else
			
				sb.logInfo( "not interacting with: "..tostring( lowsetbestid ).." "..tostring( etype ).." "..tostring( especific ) );
				
			end
		end
		
		if lowsetbestid ~= nil then
		--for k,v in pairs(directlist) do
			local etype = world.entityType( lowsetbestid )
			local especific = world.entityTypeName( lowsetbestid )
			
			--Well these objects are SORTED however, we need the position CLOSEST to the cursor...
			--So how the hell do we do that? we need intersection positions!
			--	world.lineCollision(Vec2F startPoint, Vec2F endPoint, [CollisionSet collisionKinds]) only gives us the FIRST.
			--	and that's not that useful...
			--
			
			--Json world.getObjectParameter(EntityId entityId, String parameterName, [Json defaultValue])
			--Returns the value of the specified object's config parameter, or defaultValue or nil if the parameter is not set or the entity is not an object. 

			if etype == "object" then
			
				if vsoSimulatePlayerObjectInteract( lowsetbestid, playerid ) ~= nil then
					
				end
				
			elseif etype == "npc" then
			
				if vsoSimulatePlayerNPCInteract( lowsetbestid, playerid ) ~= nil then
					
				end
			elseif etype == "monster" then
			
				--Huh... a pet maybe? well...
				
			else
				--Ignore? "player" ? others like monster maybe? vehicle? container? hm??
				
				sb.logInfo( "not interacting with: "..tostring( lowsetbestid ).." "..tostring( etype ).." "..tostring( especific ) );
			
			end
		
		end
			
	end
	
	return nil;
end

--[[
	--Huh. Fire a ray to ALL objects in range...
	--Hm.
	local doorlist = {}

	local doorIdsClosed = world.entityQuery(rect.ll(bounds), rect.ur(bounds), { includedTypes = {"object"}, callScript = "hasCapability", callScriptArgs = { "closedDoor" }, boundMode="collisionarea" } )
	for _, doorId in pairs(doorIdsClosed) do
		table.insert( doorlist, { doorId, "openDoor" } )
	end
	
	local doorIdsOpen = world.entityQuery(rect.ll(bounds), rect.ur(bounds), { includedTypes = {"object"}, callScript = "hasCapability", callScriptArgs = { "openDoor" }, boundMode="collisionarea" } )
	for _, doorId in pairs(doorIdsOpen) do
		table.insert( doorlist, { doorId, "closeDoor" } )
	end
	
	local npclist = world.npcQuery( rect.ll(bounds), rect.ur(bounds), { boundMode="collisionarea" }  );
	
	local objlist = world.objectQuery( rect.ll(bounds), rect.ur(bounds), { boundMode="collisionarea" }  );
	
	--NOW: construct a METRIC for each list.
	--Take the LOWEST RAY DISTANCE as the "best" thing to interact with...
	local hitsomething = world.lineCollision( mcontroller.position(), aimpositionclamped, { "Block", "Dynamic" } );	--{ "Null", "Block", "Dynamic", "Slippery", "Platform" }
	
	sb.logInfo( "Bounds "..tostring( bounds[1]).." "..tostring( bounds[2]).." "..tostring( bounds[3]).." "..tostring( bounds[4]) );
	if hitsomething ~= nil then
	
		sb.logInfo( "Hit something, but " );
		sb.logInfo( "doorlist" );
		for k,v in pairs(doorlist) do
			sb.logInfo( k.." = "..tostring(v) );
		end
		sb.logInfo( "npclist" );
		for k,v in pairs(npclist) do
			sb.logInfo( k.." = "..tostring(v) );
		end
		sb.logInfo( "objlist" );
		for k,v in pairs(objlist) do
			sb.logInfo( k.." = "..tostring(v) );
		end
		
		return nil;
	else
	
		return nil;
	end
	
	
	local targeteddoorid = vsoSimulatePlayerQueryFirstDoorAhead( 2 * usefacingdir, -0.5 );
	local targetednpcid = vsoSimulatePlayerQueryNPC( aimpositionclamped, radius );
	local targetedobjid = vsoSimulatePlayerQueryObject( aimpositionclamped, radius );
	
	--Which object is CLOSEST? with the priority being object, door, npc ? (it seems the "aim positon" is a "closest to line" via dp? unsure. beta skeleton idea?
	local pobjmetric = vsoSimulateWorldMetric( aimpositionclamped, targetedobjid, 0, 0 );
	local pdormetric = 1000000;
	if targeteddoorid ~= nil then
		pdormetric = vsoSimulateWorldMetric( aimpositionclamped, targeteddoorid[1], 0, 0 );
	end
	local pnpcmetric = vsoSimulateWorldMetric( aimpositionclamped, targetednpcid, 0, 0.0 );
	
	local callthis = nil
	local callargs = { nil };
	
	if pobjmetric < pdormetric then
		if pobjmetric < pnpcmetric then
			callthis = vsoSimulatePlayerObjectInteract;	--pobjmetric
			callargs = { targetedobjid, playerid }
		else
			callthis = vsoSimulatePlayerNPCInteract;	--pnpcmetric
			callargs = { targetednpcid, playerid }
		end
	elseif pdormetric < pnpcmetric then
		callthis = vsoSimulatePlayerToggleDoorsAhead;	--pdormetric
		if targeteddoorid ~= nil then
			callargs = { targeteddoorid[1], targeteddoorid[2] }
		end
	else
		callthis = vsoSimulatePlayerNPCInteract;	--pnpcmetric
		callargs = { targetednpcid, playerid }
	end
	
	--sb.logInfo( "What: "..tostring(pobjmetric).." "..tostring(pdormetric).." "..tostring(pnpcmetric) );
	
	--Vector angle : (aimposition - mcontroller.position()) targeteddoorid
	--aimposition distance to point
	--distance
	local bestinteraction = nil;
	
	--sort? Hm...
	if callthis ~= nil then
		if callargs[1] ~= nil then
			bestinteraction = callargs[1];
			local result = nil;
			if #callargs > 1 then
				if #callargs > 2 then
					result = callthis( callargs[1], callargs[2] )
				else
					result = callthis( callargs[1], callargs[2], callargs[3] )
				end
			else
				result = callthis( callargs[1] )
			end
			--local result = callthis( unpack( callargs ) );
			
		else
		end
	end
	
	--vsoSimulatePlayerObjectInteract( targetedobjid, playerid );
	--vsoSimulatePlayerToggleDoorsAhead( targeteddoorid[1], targeteddoorid[2] );
	--vsoSimulatePlayerNPCInteract( targetednpcid, playerid );
	
	--[ [
	
	--Door check
	local targeteddoorid = vsoSimulatePlayerToggleDoorsAhead( 2 * usefacingdir, -0.5 )
	if targeteddoorid ~= nil then
		
		return { "door", targeteddoorid[1], targeteddoorid[2] }
	end
	
	--NPC check
	local targetednpcid = vsoSimulatePlayerNPCInteract( targetposition, radius, playerid );
	if targetednpcid ~= nil then
	
		return { "npc", targetednpcid }
	end
	
	--Object check
	local targetedobjid = vsoSimulatePlayerObjectInteract( targetposition, radius, playerid );
	if targetedobjid ~= nil then
	
		return { "object", targetedobjid }
	end
	
	] ]--

	return bestinteraction;
end
]]--


--[[
--NO: this just needs two motion paramters
--	,"slopeSlidingFactor" :0.0
--	,"enableSurfaceSlopeCorrection" : true
--This thing will need a STATE to track it... its like pathing.

function mMoveLikeActorController_fixY( useposition, polyymin, colltypes )

	--UGH! the heck...
	local movedownpoint = world.lineCollision( { useposition[1], useposition[2]+polyymin}, { useposition[1], useposition[2] + polyymin - 1 }, colltypes )
	if movedownpoint ~= nil then
	
		local remaining = movedownpoint[2] - polyymin - useposition[2];
		
		mcontroller.translate( { 0, remaining } )
	else
		return false;--sb.logInfo( "up failed internal" );
	end
	
	return true;
	
end

function mMoveLikeActorController_collpen( collisionPoly, currpos, colltypes )

	--Problems immediately
	local cresult = world.resolvePolyCollision( collisionPoly, currpos, 1.0, colltypes ); --Ignore resolving with platforms.
	if cresult == nil then
		--game could not resolve collision
	else
		xmove = mcontroller.xPosition() - cresult[1];
		ymove = mcontroller.yPosition() - cresult[2];
		--mcontroller.accelerate( { xmove, ymove } );
		--mcontroller.translate( { xmove, ymove } )
		mcontroller.addMomentum( { xmove, ymove } )
	end
end
]]--

--[[
Motion parameters that EXIST IN THE GAME currently:
gravityMultiplier
liquidBuoyancy
airBuoyancy
bounceFactor
stopOnFirstBounce
enableSurfaceSlopeCorrection
slopeSlidingFactor
maxMovementPerStep
maximumCorrection
speedLimit
standingPoly
crouchingPoly
stickyCollision
stickyForce
walkSpeed
runSpeed
flySpeed
airFriction
liquidFriction
minimumLiquidPercentage
liquidImpedance
normalGroundFriction
ambulatingGroundFriction
groundForce
airForce
liquidForce
airJumpProfile
liquidJumpProfile
fallStatusSpeedMin
fallThroughSustainFrames
maximumPlatformCorrection
maximumPlatformCorrectionVelocityFactor
physicsEffectCategories
groundMovementMinimumSustain
groundMovementMaximumSustain
groundMovementCheckDistance
collisionEnabled
frictionEnabled
gravityEnabled
pathExploreRate
]]--

--[[
--NO: this just needs two motion paramters
--	,"slopeSlidingFactor" :0.0
--	,"enableSurfaceSlopeCorrection" : true
function mMoveLikeActorController( dt, ignoreplatforms, polyOverride )
	--The premise is to move like a player character.
	--This means you can slide along slopes, and move up single blocks.
	--Observation: moving along BLOCKS acts like SLOPES for the player.
	--    The player will not move up a --x slope. it must be looking at tiles?
	--                                  x-x
	--
	--Okay, the GENERALIZED algorithm for this should be a POLYGON CAST.
	--Since we DONT have that option...
	--	world.lineTileCollisionPoint()
	--		world.lineCollision
	--		world.lineTileCollision
	--		world.rectTileCollision
	--
	
	local collisionPoly = nil;
	if polyOverride ~= nil then 
		collisionPoly = polyOverride
	else
		collisionPoly = mcontroller.collisionPoly() 
	end
	
	--This just isnt going to work like this!
	--The heck.
	
	--Compute points on the polygon? test THEM? (well???)
	--
	--world.lineCollision(Vec2F startPoint, Vec2F endPoint, [CollisionSet collisionKinds])
	--
	--Do we have moving lines? the BOTTOM lines are what we care about ONLY.
	-- (take all points on the BOTTOM of the collision poly as "floor" ???
	--Maybe<pair<Vec2F, Vec2F>> world.lineTileCollisionPoint(Vec2F startPoint, Vec2F endPoint, [CollisionSet collisionKinds])
	--Hm...
	
	local collset = { "Block" }
	if ignoreplatforms then
		collset = {"Block"}
	else
		collset = {"Block", "Platform"} --"Dynamic"  
	end
	
	--This assumes a FLAT bottomed polygon, or at the very least a convex one.
	--local polyymin = 0.0;
	--for id, point in pairs( collisionPoly ) do
	--	if point[2] < polyymin then
	--		polyymin = point[2];
	--	end
	--end
	local collbb = mcontroller.localBoundBox();
	
	local xmove = mcontroller.xVelocity() * dt;
	local ymove = mcontroller.yVelocity() * dt;
	local currpos = { mcontroller.xPosition(), mcontroller.yPosition() }
	local nextpos = { mcontroller.xPosition() + xmove, mcontroller.yPosition() + ymove }
	
	--]]
	
	
	--[[
	local globbb = mcontroller.collisionBoundBox();
	
	local lerpFactor = math.cos(currentAngle - sinkAngle)
	local finalBuoyancy = (self.maxBuoyancy * (1.0 - lerpFactor)) + (self.sinkingBuoyancy * lerpFactor)
	
	--liquidBuoyancy = finalBuoyancy,
	--liquidFriction = self.sinkingFriction,
	--frictionEnabled = true
	--airFriction = 0,
	--groundFriction = 0,
	--liquidFriction = 0,
	--gravityEnabled = false
		
	if globbb ~= nil then
		local whynot = world.findPlatformerPath( nextpos, {nextpos[1], nextpos[2]-1}, mcontroller.parameters(), {
			returnBest = false,
			mustEndOnGround = true,
			maxDistance = 2,
			swimCost = 5,
			dropCost = 2,
			boundBox = globbb,
			droppingBoundBox = globbb,
			standingBoundBox = globbb,
			smallJumpMultiplier = 1 / math.sqrt(2), -- 0.5 multiplier to jump height
			jumpDropXMultiplier = 1,
			enableWalkSpeedJumps = true,
			enableVerticalJumpAirControl = true,
			maxFScore = 400,
			maxNodesToSearch = 20,
			maxLandingVelocity = -10.0,
			liquidJumpCost = 15
		  } );
		
	end
	]]--
	
	
	--[[
	
	--Find MINIMUM y position in collision polygon??? or the Y position at CENTER?
	--Not sure about this one.
	
	--local collpoints = world.lineTileCollisionPoint( {nextpos[1], nextpos[2]+1}, {nextpos[1], nextpos[2]-1}, collset );
	--if collpoints then
	--	for idx,val in pairs( collpoints ) do
	--		sb.logInfo( tostring(idx).." "..tostring(val[1])..","..tostring(val[2]) );
	--	end
	--end
	
	--Can we EVEN GET THIS TO WORK?
	--step size is 1/16th a pixel??
	--Still unsure how to "stay on ground" -> move into ground, and resolve?
	local hitsnow = world.polyCollision( collisionPoly, currpos, {"Block"} )
	local hitsnext = world.polyCollision( collisionPoly, nextpos, collset )
	
	if hitsnow then
	
		mMoveLikeActorController_collpen( collisionPoly, currpos, {"Block"} );
	
		return true;
		
	elseif hitsnext then
	
		if mcontroller.yVelocity() <= 0 then
		
			--the NEXT position is colliding? (move UP)
			local upmove = 1/16.0;
			while upmove <= 1.0 do
				if world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] + upmove }, collset ) then
					upmove = upmove + 1/16.0;
				else
					--sb.logInfo( "forced upmove: "..tostring( upmove ) );
					--nextpos[2] = nextpos[2] + upmove - 1/16.0
					--mcontroller.accelerate( { 0, upmove } );
					--mcontroller.translate( { 0, upmove - 1/16.0  } )
					mcontroller.addMomentum( { 0, upmove - 1/16.0  } )
					--mcontroller.addMomentum( { 0, upmove - 1/16.0  } )
					--mMoveLikeActorController_collpen( collisionPoly, currpos, {"Block"} );
					--mcontroller.setYVelocity( -1/16.0 );--mcontroller.setYVelocity( 0.0 );
					break;
				end
			end
		
			return true;
		end
		
		--if not mcontroller.onGround() then
		--if not mMoveLikeActorController_fixY( nextpos, polyymin, collset ) then
		--	mcontroller.translate( { 0,  mcontroller.yPosition() + ymove - nextpos[2] } )
		--end
		--end
		
	else
	
		--Are we... moving? along a tile set?
	
		--the NEXT position is NOT colliding (move DOWN?)
		local downmove = -1/16.0;
		while downmove >= -1.0 do
			if not world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] + downmove }, collset ) then
				downmove = downmove - 1/16.0;
			else
				--sb.logInfo( "forced downmove: "..tostring( downmove ) );
				--nextpos[2] = nextpos[2] + downmove + 1/16.0
				--mcontroller.translate( { 0, downmove } )
				mcontroller.addMomentum( { 0, downmove } )
				--mcontroller.accelerate( { 0, downmove } );
				--mcontroller.setYVelocity( -1/16.0 );--0.0 );
				--mMoveLikeActorController_collpen( collisionPoly, currpos, {"Block"} );
				break;
			end
		end
		
		return true;
		--if not mcontroller.onGround() then
			--UGH! the heck...
			--mcontroller.translate( { 0, - 1/16.0 } )
		--if not mMoveLikeActorController_fixY( nextpos, polyymin, collset ) then
		--	mcontroller.translate( { 0,  mcontroller.yPosition() + ymove - nextpos[2] } )
		--end
		--end
		
	end
	
	return false;
	
end

function mTestdistanceToGround( point, maxdownsearch )
  local endPoint = vec2.add(point, {0, -maxdownsearch})

  local intPoint = world.lineCollision(point, endPoint, { "Block", "Platform" }) --{ "Block", "Dynamic" }

  if intPoint then
    world.debugLine(point, intPoint, {255, 255, 0, 255})
	return point[2] - intPoint[2]
  else
    world.debugLine(point, endPoint, {128, 128, 0, 255})
	return maxdownsearch
  end
end

function mMotionTestPolycast( polygon, position, direction, length, collset )

	local substep = 1/16.0;
	local nsteps = length/substep;
	local pos = { position[1], position[2] }
	while nsteps > 0 do
		if world.polyCollision( polygon, pos, collset ) then	--if my NEXT position in x IS colliding...
			return pos;
		end
		pos = { pos[1] + direction[1]*substep, pos[2] + direction[2]*substep }
		nsteps = nsteps - 1;
	end
	return nil;

end

]]--

--[[
function mMoveLikeActorController_original( dt, ignoreplatforms, polyOverride )

	--HEY LOOK: world.lineCollision(point, endPoint) is useful! from sportscar.lua
	--
	--	function distanceToGround(point)
	--	  local endPoint = vec2.add(point, {0, -self.maxGroundSearchDistance})
	--
	--	  world.debugLine(point, endPoint, {255, 255, 0, 255})
	--	  local intPoint = world.lineCollision(point, endPoint)
	--
	--	  if intPoint then
	--		world.debugPoint(intPoint, {255, 255, 0, 255})
	--		return point[2] - intPoint[2]
	--	  else
	--		return self.maxGroundSearchDistance
	--	  end
	--	end
	
	
	--This MAY require a totally different strategy.
	--IE, we may have to "track" a "target" position (that is RESET once we are ON THE GROUND to 0.5 above the terrain...)
	--Much like the pathing algorithm? Hm...
	--Then, when you "lose control" of that target lock (off the ground, stunned, etc)
	--we wait till we can reset it to continue traversing it along the ground...
	--This is OK so long as the collision box's bottom is consistent? (lowest side is what we care about?)
	

	--Requires to have PREVIOUSLY been on the ground...
	--And that we are in POSITIVE control
	
	--CURRENT PROBLEMS (2019-06-20)
	--	Walking down a slope DOUBLES velocity forward, for some reason?
	--	Still poppy glitches sometimes. Unsure what condition it is. Mostly good.
	--	Standing on a slope slides you down the slope...
	--	When you slide down a slope a bit, it doesnt work walking up the slope anymore.
	
	--We assume that the "grid" cells we are looking at are the problem...
	--So if we can compute the CURRENT "forward" integer coordinates, then we can check THAT way...
	--	using math.round, you know. IE computing from the forward edge? Hm...
	
	--Use mcontroller.localBoundBox() so rotations are right out?
	--	Huh... then its easier at least to compute POSSIBLE tile collisions? ...
	
	
	--listens to x and y velocity.
	--Move like an actor controller.
	--local onground = mcontroller.onGround()
	--local onsomething = mcontroller.isColliding()
	--if onground or onsomething then
	
	if mcontroller.yVelocity() <= 0 then
	
		--Okay, but. moving TO the position may just be blatantly ignored?
		--Unsure how player movement logic works here...
		--    It seems to just hop UP at most 1 tile from current position?
		--    Strange. Maybe its just collision box woes? tuck in the corners better?
		--
		local xmovetrue = mcontroller.xVelocity() * dt;
		local ydowntrue = mcontroller.yVelocity() * dt;
		local xmovetrueabs = math.min( 1, math.abs( xmovetrue ) );
		local xmovetrueclamped = xmovetrue;
		if xmovetrueclamped < -1 then xmovetrueclamped = -1; elseif xmovetrueclamped > 1 then xmovetrueclamped = 1 end
		
		local collisionPoly = polyOverride;
		if collisionPoly == nil then 
			collisionPoly = mcontroller.collisionPoly() 
		end--what is this returning?
		
		local xfinaldelta = 0;
		local yfinaldelta = 0;
		
		--binary Iterative stepdown checking? shouldn't we KNOW this from the TILE data itself?
		--Well?
		local nextpos = { mcontroller.xPosition() + xmovetrue, mcontroller.yPosition() }
		
		local collset = { "Block" }
		if ignoreplatforms then
			collset = {"Block"}
		else
			collset = {"Block", "Platform"} --"Dynamic"
		end
		
		
		--local forwardbit = world.polyCollision( collisionPoly, nextpos, collset )
		--local forwardupbit = world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] + abs( xmovetrue ) }, collset )
		--local forwarddownbit = world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] - abs( xmovetrue ) }, collset )
		
		--local ydeltaamt = abs(ydowntrue);
		
		if world.polyCollision( collisionPoly, nextpos, collset ) then	--if my NEXT position in x IS colliding...
		
			if not world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] + 1 }, collset ) then	--If the next position + 1 y is NOT colliding
			
				--Resolve to VERTICAL position.
				local ydelta = 0.5;
				local ylimit = 0.5 / 8;--0.001953125;
				while ydelta >= ylimit do	--0.5/8
					--ydelta = ydelta / 2.0;
					if world.polyCollision( collisionPoly, nextpos, collset ) then
						nextpos[2] = nextpos[2] + ydelta;
					else
						nextpos[2] = nextpos[2] - ydelta;
					end
					ydelta = ydelta / 2.0;
				end
				local deltaup = nextpos[2] - mcontroller.yPosition()
				if deltaup > ylimit then
					--sb.logInfo( "y result delta up: "..tostring( deltaup ) );
				
					yfinaldelta = deltaup;
					--mcontroller.translate( { 0, deltaup - ylimit } )	--Results in a UNSTABLE position configuration?
				end
			end
		elseif (
			world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] - 1 }, collset ) 
			--and world.polyCollision( collisionPoly, { nextpos[1], nextpos[2] - 2 }, collset ) 
			)
		then --then my NEXT x position minus 1 tile must NOT be colliding...
		
			--Can we STEP DOWN? SHOULD we?
			--Resolve to VERTICAL position. Note that we SHOULD be able to determine the EXACT polygon "height" at a point vs the grid...
			local ydelta = 0.5;
			local ylimit = 0.5 / 8;--0.001953125;
			while ydelta >= ylimit do	--0.5/8
				--ydelta = ydelta / 2.0;
				if world.polyCollision( collisionPoly, nextpos, collset ) then
					nextpos[2] = nextpos[2] + ydelta;
				else
					nextpos[2] = nextpos[2] - ydelta;
				end
				ydelta = ydelta / 2.0;
			end
			local deltadown = nextpos[2] - mcontroller.yPosition()
			if deltadown < -ylimit then
			
				--sb.logInfo( "y result delta down: "..tostring( deltadown ) );
			
				yfinaldelta = deltadown;
				--mcontroller.translate( { 0, deltadown - ylimit } )	--Results in a UNSTABLE position configuration?
			end
			
			--[00:16:29.912] [Info] y result delta up: 0.00023871345661064
			--[00:16:29.928] [Info] y result delta down: -0.0009765625
		end
		
		if yfinaldelta ~= 0 then
			--yfinaldelta = yfinaldelta + ydowntrue;	--Hmmmm could be dangerous...
			if xfinaldelta ~= 0 then
				mcontroller.translate( { xfinaldelta, yfinaldelta } )
			else
				--mcontroller.translate( { 0, yfinaldelta - 1.0/16.0 } )
				mcontroller.translate( { 0, yfinaldelta } )
			end
			
			-- if not mcontroller.onGround() then
				-- local ncount = 0;
				-- while not mcontroller.onGround() do
					-- mcontroller.translate( { 0, -1/16.0 } )
					-- ncount = ncount + 1;
					-- if ncount > 16 then
						-- break
					-- end
				-- end
				
				-- sb.logInfo( "didnt work "..tostring(ncount) );
			-- end
			Make SURE mcontroller.onGround() returns true...
			How do we do this?
			
		end
		
		--world.polyCollision( collisionPoly, { mcontroller.xPosition() + ?, mcontroller.yPosition() + 0.0 }, {"Block", "Dynamic", "Platform"} )
	
	
	
		--local towardGround = { mcontroller.xPosition(), mcontroller.yPosition() + 0.125 }
		--local groundPosition = world.resolvePolyCollision( collisionPoly, towardGround, 1.0, {"Null", "Block", "Dynamic", "Platform"} )
		--if groundPosition and not (groundPosition[1] == towardGround[1] and groundPosition[2] == towardGround[2]) then
		
			--Huh... ydowntrue vs ydown??
		--	local deltaposx = groundPosition[1] - mcontroller.xPosition();
		--	local deltaposy = groundPosition[2] - mcontroller.yPosition();
		--	sb.logInfo( tostring( deltaposx ) .." "..tostring( deltaposy ).." deltapos" );
		--	mcontroller.translate( { deltaposx, deltaposy } )
			
--[23:56:40.926] [Info] -0.06298828125 0.06201171875 deltapos
--[23:56:40.941] [Info] -0.0625 0.0625 deltapos

		--else
		--	--? failed?
		--end

	end
		
	--world.polyCollision(PolyF poly, [Vec2F position], [CollisionSet collisionKinds])
	--world.resolvePolyCollision(PolyF poly, Vec2F position, float maximumCorrection, [CollisionSet collisionKinds])
	
	--must be ON THE GROUND to do this check...
	--is our next position going to collide?
	--if so, move it up 1 tile.
	--recurse? Hm... accuracy limit???
	--if onsomething then
		--May be stuck or pushing into/against a thing.
	--else
		--just on the ground. Normal
	--end

end

]]--
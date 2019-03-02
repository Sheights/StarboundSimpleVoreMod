--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Zovoroth

function init()
  --self.chatOptions = config.getParameter("chatOptions", {})
  --self.chatTimer = 0
  
  animator.setAnimationState("bodyState", "closed");
  
  self.interactData = root.assetJson( "/interface/scripted/spovpillstation/spovpillstationgui.config" )
  object.setInteractive( true );
  
	message.setHandler("setAnimationState",
		function(_, _, state, anim)
			animator.setAnimationState( state, anim );
		end)
end

--animator.setAnimationState("shopState", "closed");

function onInteraction(args)
  
  self.interactData.ownerId = entity.id();
  
  return { "ScriptPane", self.interactData }
end

function update(dt)
  --[[
  self.chatTimer = math.max(0, self.chatTimer - dt)
  if self.chatTimer == 0 then
    local players = world.entityQuery(object.position(), config.getParameter("chatRadius"), {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
    })

    if #players > 0 and #self.chatOptions > 0 then
      object.say(self.chatOptions[math.random(1, #self.chatOptions)])
      self.chatTimer = config.getParameter("chatCooldown")
    end
  end
  ]]--
end
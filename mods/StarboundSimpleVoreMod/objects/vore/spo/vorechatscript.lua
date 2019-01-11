require "/scripts/vec2.lua"
ohSnap = false

-- Makes detection area around the predatores.
function init(virtual)
  if not virtual then
    self.detectArea = config.getParameter("detectArea")
  end
-- Imports the lines from the predatores object file.
  chatOptions = config.getParameter("chatOptions", {})
  gulpLines = config.getParameter("gulpLines", {})
  rubLines = config.getParameter("rubLines", {})
  initHook()
end

function update(args)
  
-- Sets the state of the predatore to "isFull" when someone is inside of it.
  isFull = world.loungeableOccupied(entity.id())
-- Uses the previously made detection area to say the IdleFull or IdleEmpty lines when a player is closeby.
  local players = world.entityQuery( object.position(), 7, {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
    })
  local chatIdleEmpty = config.getParameter("chatIdleEmpty", {})
  local chatIdleFull = config.getParameter("chatIdleFull", {})
-- Only displays the lines if more than 0 players are in, and ohSnap is false (to prevent spam).
	if #players > 0 and not ohSnap then
-- Displays the empty lines if the predator is empty, else full.
	  if world.loungeableOccupied(entity.id()) == false then
-- But only if it isnt already displaying a line.
	    if #chatIdleEmpty > 0 then
		  object.say(chatIdleEmpty[math.random(1, #chatIdleEmpty)])
		end
	  else
	    if #chatIdleFull > 0 then
		  object.say(chatIdleFull[math.random(1, #chatIdleFull)])
		end
	  end
	  ohSnap = true
-- Sets ohSnap to false when no players are within the dection area.
	elseif #players == 0 and ohSnap then
	  ohSnap = false
	end
-- Randomly displays the "Player inside Pred" lines with soundeffects.
  if isFull and math.random(150) == 1 then
	if #chatOptions > 0 then
      object.say(chatOptions[math.random(1, #chatOptions)])
	  if math.random(3) == 1 then
	    animator.playSound("belly1")
	  elseif math.random(2) == 1 then
	    animator.playSound("belly2")
	  else
	    animator.playSound("belly3")
	  end
    end
  end
  updateHook()
end

function onInteraction(args)

  if not prey then
    prey = nil
  end
-- Unless the predator is full it will activate this code.
  if isFull == false then
-- Swallows the prey, playing the gulp sound and displaying a line. Also sets the player to be "prey".
    if #gulpLines > 0 then
      object.say(gulpLines[math.random(1, #gulpLines)])
	  animator.playSound("swallow")
	  prey = args.sourceId
    end
-- If the interaction is done by someone NOT flagged as this predators prey then the RubLines are displayed.
  elseif isFull and prey ~= args.sourceId then
    if #rubLines > 0 then
      object.say(rubLines[math.random(1, #rubLines)])
	end
-- Old code. Left in inside it will work again someday.
  elseif isFull then
    if #chatOptions > 0 then
      object.say(chatOptions[math.random(1, #chatOptions)])
    end
  end
end

function initHook() end
function updateHook() end
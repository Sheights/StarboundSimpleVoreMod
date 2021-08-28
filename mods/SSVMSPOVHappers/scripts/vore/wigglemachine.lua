-------------------------------------------------------------------------------
-- UTILS
-------------------------------------------------------------------------------

--[[Deep Copy
  recursive copy of a table
  http://lua-users.org/wiki/CopyTable
]]--
local function deepcopy (orig, copies)
  local orig_type = type(orig)
  local copy

  copies = copies or {}

  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}

      for orig_key, orig_value in next, orig, nil do
        copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
      end

      copies[orig] = copy
      setmetatable(copy, deepcopy(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end

  return copy
end
-- I do want a different table for each seat~

-- if any counter has ended, returns the movetype and movedir with a priority on struggles and the MAX can get overwritten
-- if not, returns -1 and nil
local function checkStatus (seat, movetype, typeResult, directionResult)
  if not typeResult then typeResult = -1 end
  if not directionResult then directionResult = nil end

  if not seat then return typeResult, directionResult end
  if not wiggleMachines[seat] then return typeResult, directionResult end

  if not movetype then return typeResult, directionResult end -- all above are just security checks

  for k, v in pairs(wiggleMachines[seat][movetype]) do -- check every struggle counter
    if v == 0 then -- if a counter is at 0
      if typeResult < 0 then typeResult = 1 end -- set the type result without overwritting anything
      if not directionResult or directionResult == "MAX" then directionResult = k end -- set the direction result without overwritting anything BUT MAX
    end
  end

  return typeResult, directionResult
end

-------------------------------------------------------------------------------
-- WIGGLE MACHINE CORE
-------------------------------------------------------------------------------

--[[The Wiggle Machine!
  WHAT DID YOU DO AND WHY?! WTH?!?

  I was TIRED of having to scramble my mind each time I want to add some wiggles logic
  You have to check if the guy simply presses the button or if he holds it
  You have to recover the direction of the wiggle
  With NPCs it's all messed up
  AND IT'S NOT EVEN THE WORST PART
  After that there is the animation that has to play
  Should we play it at the end of non-wiggle anim?
  Should we play it even if there is a wiggle anim going on?
  Oh the sound! ofc! only play sound when you wiggle!
  AND THE LIST GOES ON (IE multi vore/multi animation state...)

  THAT is why I made some kind of API for it! :3
  configure it! (sound, animations, # of wiggles (pleases and/or struggles))
  update it every vsoDelta()
  and get the status when it is finished! (returns a number like movetype and a string between one of those: ["MAX", "F", "U", "B", "D"]. "MAX" gets overwritten btw!)
  Just get in mind each function for those configurations are in that order: F, U, B, D  (take the front as the right side then CCW)

  Oh and you HAVE to pass a seat (multivore friendly, yay!) AND a state (IE bodyState, WAIT WHAT MULTISTATE WOOHOO)
]]--

wiggleMachines = {} -- contains a machine per seat
wiggleMachine = {} -- a machine for a seat
wiggleMachine_config = {} -- the configurations for a seat
wiggleMachine_base = {} -- the base value for a seat
wiggleMachine_anims = {} -- base animations for a seat

-------------------------------------------------------------------------------

wiggleMachine_config["BWM"] = false -- Break Wiggle Machine. Should it wiggle while already wiggling? If not: cancel any next anim!
wiggleMachine_config["WFE"] = false -- Wait For End. Should it wait for the end of any animation before playing? If yes: queue the animation
wiggleMachine_config["PS"] = true -- Play Sound. Pretty explicit, heh?

-------------------------------------------------------------------------------

wiggleMachine_anims["F"] = nil -- anim front
wiggleMachine_anims["U"] = nil -- anim up
wiggleMachine_anims["B"] = nil -- anim back
wiggleMachine_anims["D"] = nil -- anim down

-------------------------------------------------------------------------------

wiggleMachine_base["MAX"] = 15 -- max number of wiggles
wiggleMachine_base["F"] = 8 -- max number of wiggles front
wiggleMachine_base["U"] = 8 -- max number of wiggles up
wiggleMachine_base["B"] = 8 -- max number of wiggles back
wiggleMachine_base["D"] = 8 -- max number of wiggles down
wiggleMachine_base["SOUND"] = nil -- sound key to play
wiggleMachine_base["ANIM"] = deepcopy(wiggleMachine_anims) -- SPOV/VSO animations

-------------------------------------------------------------------------------

wiggleMachine["CONFIG"] = deepcopy(wiggleMachine_config) -- config for the seat
wiggleMachine[1] = deepcopy(wiggleMachine_base) -- struggles
wiggleMachine[2] = deepcopy(wiggleMachine_base) -- pleases

-------------------------------------------------------------------------------
-- WIGGLE MACHINE INIT
-------------------------------------------------------------------------------

-- "init" function for each seat, called by default if it wasn't called before
function wiggleMachine.setSeat (seat)
  wiggleMachines[seat] = deepcopy(wiggleMachine) -- a machine for each seat, here we go!
  wiggleMachines[seat]["DIRECTION"] = nil -- next direction to use for animation
  wiggleMachines[seat]["MOVETYPE"] = nil -- next movetype to use for animation
end

-------------------------------------------------------------------------------
-- WIGGLE MACHINE MAIN FUNCTIONS
-------------------------------------------------------------------------------

-- here comes all the wiggle updates
-- give it a seat and a state then it will return the movetype & the movedir when it plays an animation!
-- if it plays no animations or if it cancels one, returns -1, nil
function wiggleMachine.update (seat, state)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  local anim = vsoAnimCurr(state)
  local entityid = vehicle.entityLoungingIn(seat)
  local movetype, movedir = vso4DirectionInput(seat)
  local config = wiggleMachines[seat]["CONFIG"] -- just get the current config
  local moveResult = -1
  local dirResult = nil

  if not entityid then return moveResult, dirResult end -- no entity, no issues
  if not world.entityExists(entityid) then return moveResult, dirResult end -- no entity, no issues

  -- if it's a NPC do some random anims!
  if world.isNpc(entityid) then
    movetype = -1 -- sometimes NPCs move around randomly, DON'T DO THAT PLEASE

    if vsoChance(1) then
      movetype = vsoPick({ 1, 2 })
    end

    if movetype > 0 then
      movedir = vsoPick({ "F", "U", "B", "D" })
    end
  end

  -- if there is no direction selected, select one please
  if not wiggleMachines[seat]["DIRECTION"] then
    if movetype > 0 and movedir ~= "J" then
      wiggleMachines[seat]["MOVETYPE"] = movetype
      wiggleMachines[seat]["DIRECTION"] = movedir
    end
  end

  -- don't continue if no selections
  if not wiggleMachines[seat]["DIRECTION"] or not wiggleMachines[seat]["MOVETYPE"] then return moveResult, dirResult end

  if vsoAnimEnd(state) then -- just in case we were at the end of the current animation, don't check anything, just play it
    wiggleMachine.play(seat, state, wiggleMachines[seat]["MOVETYPE"], wiggleMachines[seat]["DIRECTION"], config["PS"])

    moveResult = wiggleMachines[seat]["MOVETYPE"]
    dirResult = wiggleMachines[seat]["DIRECTION"]

    wiggleMachines[seat]["DIRECTION"] = nil
    wiggleMachines[seat]["MOVETYPE"] = nil
  elseif not config["WFE"] then -- if we don't wait for any anim to end
    local isSame = false
    local sanims = wiggleMachines[seat][1] -- recover every struggle anim
    local panims = wiggleMachines[seat][2] -- recover every please anim

    if anim == sanims["ANIM"]["F"] or anim == sanims["ANIM"]["U"] or anim == sanims["ANIM"]["B"] or anim == sanims["ANIM"]["D"] then
      isSame = true -- the current animation is the same as the next we want to play for struggles
    end

    if anim == panims["ANIM"]["F"] or anim == panims["ANIM"]["U"] or anim == panims["ANIM"]["B"] or anim == panims["ANIM"]["D"] then
      isSame = true -- the current animation is the same as the next we want to play for wiggles
    end

    if not config["BWM"] and isSame then -- if we don't break the wigglemachine and the animations are the same, cancel it
      wiggleMachines[seat]["DIRECTION"] = nil
      wiggleMachines[seat]["MOVETYPE"] = nil
    else -- if the animation are not the same or if the configuration says "break the wiggle machine", play the animation
      wiggleMachine.play(seat, state, wiggleMachines[seat]["MOVETYPE"], wiggleMachines[seat]["DIRECTION"], config["PS"])
      moveResult = wiggleMachines[seat]["MOVETYPE"]
      dirResult = wiggleMachines[seat]["DIRECTION"]

      wiggleMachines[seat]["DIRECTION"] = nil
      wiggleMachines[seat]["MOVETYPE"] = nil
    end
  end

  return moveResult, dirResult
end

-------------------------------------------------------------------------------

-- play the animation yourself! (this is called by the wiggleMachine.update function)
-- needs a seat, an animation state, a movetype (1-struggle | 2-please), a direction (F, U, B, D) and if it has a sound or not
function wiggleMachine.play (seat, state, wmtype, direction, hasSound)
  local nextAnim = nil

  -- I do not want any crash, sir!
  if not wiggleMachines[seat] then
    return false
  elseif seat and wmtype >= 1 and wmtype <= 2 and (direction == "F" or direction == "U" or direction == "B" or direction == "D") then
    nextAnim = wiggleMachines[seat][wmtype]["ANIM"][direction]
  else
    return false
  end

  if state and nextAnim then vsoAnim(state, nextAnim) end -- play the animation

  if hasSound and wiggleMachines[seat][wmtype]["SOUND"] then
    vsoSound(wiggleMachines[seat][wmtype]["SOUND"]) -- play the sound
  end

  -- decrement the specific wiggle count
  wiggleMachines[seat][wmtype][direction] = wiggleMachines[seat][wmtype][direction] - 1
  wiggleMachines[seat][wmtype]["MAX"] = wiggleMachines[seat][wmtype]["MAX"] - 1

  if wiggleMachines[seat][wmtype][direction] <= 0 then -- check if a direction count's gone to 0
    wiggleMachines[seat][wmtype][direction] = 0
    wiggleMachines[seat][wmtype]["MAX"] = 0
  end

  if wiggleMachines[seat][wmtype]["MAX"] <= 0 then -- check if the maximum count's gone to 0
    wiggleMachines[seat][wmtype]["MAX"] = 0
  end
end

-------------------------------------------------------------------------------

-- get the wiggle status for a seat
function wiggleMachine.getStatus (seat)
  local typeResult, directionResult = checkStatus(seat, 1)

  typeResult, directionResult = checkStatus(seat, 2, typeResult, directionResult)

  return typeResult, directionResult
end

-------------------------------------------------------------------------------
-- WIGGLES CONFIG SETTERS
-------------------------------------------------------------------------------

-- tell me if you want to wiggle while already wiggling!
function wiggleMachine.setConfigBreakWMSeat (seat, isBWM)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat]["CONFIG"]["BWM"] = isBWM
end

-------------------------------------------------------------------------------

-- tell me if you want to wait for ANY animation to end before you wiggle!
function wiggleMachine.setConfigWaitForEndSeat (seat, isWFE)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat]["CONFIG"]["WFE"] = isWFE
end

-------------------------------------------------------------------------------

-- tell me if you want some to play the sound you've put!
function wiggleMachine.setConfigPlaySoundSeat (seat, isPS)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat]["CONFIG"]["PS"] = isPS
end

-------------------------------------------------------------------------------
-- WIGGLES COUNTERS, ANIMATIONS AND SOUND SETTERS -- ALL WIGGLE TYPES
-------------------------------------------------------------------------------

-- sets the max counter for both wiggle types for a seat
function wiggleMachine.setMaxAll (seat, n)
  wiggleMachine.setMaxStruggles(seat, n)
  wiggleMachine.setMaxPleases(seat, n)
end

-------------------------------------------------------------------------------

-- sets each wiggling direction's counter for both wiggle types for a seat (front, up, back, down)
function wiggleMachine.setMax4DAll (seat, nF, nU, nB, nD)
  wiggleMachine.setMax4DStruggles(seat, nF, nU, nB, nD)
  wiggleMachine.setMax4DPleases(seat, nF, nU, nB, nD)
end

-------------------------------------------------------------------------------

-- sets a sound to play while wiggling
function wiggleMachine.setSoundAll (seat, sound)
  wiggleMachine.setSoundStruggles(seat, sound)
  wiggleMachine.setSoundPleases(seat, sound)
end

-------------------------------------------------------------------------------

-- sets each wiggling animation's counter for both wiggle types for a seat (front, up, back, down)
function wiggleMachine.setAnimAll (seat, animF, animU, animB, animD)
  wiggleMachine.setAnimStruggles(seat, animF, animU, animB, animD)
  wiggleMachine.setAnimPleases(seat, animF, animU, animB, animD)
end

-------------------------------------------------------------------------------
-- WIGGLES COUNTERS, ANIMATIONS AND SOUND SETTERS -- STRUGGLES
-------------------------------------------------------------------------------

-- Refer to "ALL WIGGLE TYPES"

function wiggleMachine.setMaxStruggles (seat, n)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][1]["MAX"] = n
end

-------------------------------------------------------------------------------

function wiggleMachine.setMax4DStruggles (seat, nF, nU, nB, nD)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][1]["F"] = nF
  wiggleMachines[seat][1]["U"] = nU
  wiggleMachines[seat][1]["B"] = nB
  wiggleMachines[seat][1]["D"] = nD
end

-------------------------------------------------------------------------------

function wiggleMachine.setSoundStruggles (seat, sound)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][1]["SOUND"] = sound
end

-------------------------------------------------------------------------------

function wiggleMachine.setAnimStruggles (seat, animF, animU, animB, animD)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][1]["ANIM"]["F"] = animF
  wiggleMachines[seat][1]["ANIM"]["U"] = animU
  wiggleMachines[seat][1]["ANIM"]["B"] = animB
  wiggleMachines[seat][1]["ANIM"]["D"] = animD
end

-------------------------------------------------------------------------------
-- WIGGLES COUNTERS, ANIMATIONS AND SOUND SETTERS -- PLEASES
-------------------------------------------------------------------------------

-- Refer to "ALL WIGGLE TYPES"

function wiggleMachine.setMaxPleases (seat, n)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][2]["MAX"] = n
end

-------------------------------------------------------------------------------

function wiggleMachine.setMax4DPleases (seat, nF, nU, nB, nD)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][2]["F"] = nF
  wiggleMachines[seat][2]["U"] = nU
  wiggleMachines[seat][2]["B"] = nB
  wiggleMachines[seat][2]["D"] = nD
end

-------------------------------------------------------------------------------

function wiggleMachine.setSoundPleases (seat, sound)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][2]["SOUND"] = sound
end

-------------------------------------------------------------------------------

function wiggleMachine.setAnimPleases (seat, animF, animU, animB, animD)
  if not wiggleMachines[seat] then wiggleMachine.setSeat(seat) end

  wiggleMachines[seat][2]["ANIM"]["F"] = animF
  wiggleMachines[seat][2]["ANIM"]["U"] = animU
  wiggleMachines[seat][2]["ANIM"]["B"] = animB
  wiggleMachines[seat][2]["ANIM"]["D"] = animD
end

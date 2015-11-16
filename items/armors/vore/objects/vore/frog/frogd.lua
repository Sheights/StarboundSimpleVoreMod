croakLock		= 0
spitLock		= 0

timer			= 0
timerChew		= 0
timerDigest		= 0
timerEat		= 0
timerSwallow	= 0

prey			= nil
preyCur			= 0
preyMax			= 1

function init()

end

function update(dt)
	if world.loungeableOccupied(entity.id()) then
	
		if prey ~= nil then
			preyCur = world.entityHealth(prey)[1] * 100
		end

		if timerSwallow > 50 then
			if timerDigest % 13 == 0 then
				entity.playSound("digest")
			end
			
			entity.setAnimationState("main", "digest")
			timerDigest = timerDigest + 1

		elseif math.floor( preyCur / preyMax ) < 50 and timerEat > 28 then
			if timerSwallow == 0 then
				entity.playSound("swallow")
			end
			
			entity.setAnimationState("main", "swallow")
			timerSwallow = timerSwallow + 1

		elseif timerEat > 28 then
			if timerChew % 13 == 0 and timerChew > 10 then
				entity.playSound("chew")
			end
			
			entity.setAnimationState("main", "chew")
			timerChew = timerChew + 1

		else
			if timerEat == 0 then
				entity.playSound("eat")
			end
			
			entity.setAnimationState("main", "eat")
			timerEat = timerEat + 1
		end

	else
		if prey ~= nil then
			if math.floor( preyCur / preyMax ) <= 2 then
				timerSwallow = 0
			end
		end
		
		if timerSwallow > 50 then			
			entity.setAnimationState("main", "spit")
			spitLock = 1
		end

		timerChew = 0
		timerDigest	= 0
		timerEat = 0
		timerSwallow = 0

		if croakLock == 0 and spitLock == 0 and math.random(200) == 1 then
			croakLock = 1
			entity.setAnimationState("main", "croak")
			entity.playSound("croak")

		elseif croakLock == 0 and spitLock == 0 then
			entity.setAnimationState("main", "idle")
		end

		if croakLock == 1 or spitLock == 1 then
			timer = timer + 1
		end

		if timer > 15 and croakLock == 1 then
			croakLock = 0
			timer = 0
		elseif spitLock == 1 then		
			if timer == 1 then
				entity.playSound("swallow")
			elseif timer == 25 then
				entity.playSound("eat")
			elseif timer > 46 then
				spitLock = 0
				timer = 0
			end
		end
	end
end

function onInteraction(args)
	prey = args.sourceId
	preyMax = world.entityHealth(prey)[2]
end
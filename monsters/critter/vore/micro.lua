oldInit = init
oldInteract = interact
oldUpdate = update
function init()

	tempUpdate = update
	tempInteract = interact
	
	oldInit()
	monster.setInteractive(true)
	sb.logInfo("micro is being initialized")
	
	update = tempUpdate
	interact = tempInteract
	
end

function interact( args )

	sb.logInfo("ping")
	oldInteract(args)
	--give food buff
	world.sendEntityMessage( args.sourceId, "applyStatusEffect", "microeat", 1, entity.id() )
	--die
	status.setResource("health", 0)
	

	return nil
	
end

function update(dt)

	tempUpdate = update
	tempInteract = interact
	oldUpdate(dt)
	update = tempUpdate
	interact = tempInteract

end
fed = false
blink = false

gurgles = {
	"belly1",
	"belly2",
	"belly3"
}

chatOptions = {
	"Mmmmmmmm~",
	"Oooh, keep wriggling~",
	"Enjoying yourself in there? I know I am~",
	"So full~",
	"<3 <3 <3",
	"Heh, maybe I should charge rent.",
	"Stay as long as you want~",
	"This feels so great I might have to keep you inside forever~",
	"I be fulla happy people~"
}

gulpLines = {
	"In you go~",
	"Best bed in the galaxy~",
	"Enjoy your stay~",
	"Weclome to Casa de Me~"
}

chatIdleFull = {
	"Sorry, no vacancies~",
	"Come back later~",
	"Sorry, one person per... room~"
}

chatIdleEmpty = {
	"Come on in~",
	"We have vacancies~",
	"I've got some room to rent over here~",
	"Are you as tasty as you look~?",
	"Up for some fun hon~?",
	"I've got a warm belly to escape the colds of space~",
	"Hey spacer, I got a space for you right in here~",
	"Why build a house when you could move into me~?"
}

rubLines = {
	"You're pretty good at this, mind doing it for longer?",
	"Ooohh! Thanks for the massage ~",
	"Now i'm getting a massage from both sides.",
	"I love a good belly rub ~"
}

function init()
	object.setInteractive(true)
end

function onInteraction(args)
	if world.loungeableOccupied(entity.id()) then
		object.say( rubLines[ math.random(#rubLines) ])
	end
end

function update(dt)
	if math.random(350) == 1 then
		if world.loungeableOccupied(entity.id()) then
			local people = world.entityQuery( entity.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"npc", "player"},
				boundMode = "CollisionArea"
			})
			if math.random(2) == 1 and #people > 2 then
				object.say( chatIdleFull[ math.random(#chatIdleFull) ])
				animator.playSound( gurgles[ math.random(#gurgles) ] )
			else
				object.say( chatOptions[ math.random(#chatOptions) ])
				animator.playSound( gurgles[ math.random(#gurgles) ] )
			end
		else
			object.say( chatIdleEmpty[ math.random(#chatIdleEmpty) ])
		end
	end
	if math.random(400) == 1 and world.loungeableOccupied(entity.id()) then
		animator.playSound( gurgles[ math.random(#gurgles) ] )
	end

	if world.loungeableOccupied(entity.id()) and animator.animationState("bodyState") == "idle" then
		animator.setAnimationState("bodyState", "full")
		object.say( gulpLines[ math.random(#gulpLines) ])
		animator.playSound("swallow")
	elseif world.loungeableOccupied(entity.id()) == false and animator.animationState("bodyState") == "full" then
		animator.setAnimationState("bodyState", "idle")
		animator.playSound("spit")
	end
end
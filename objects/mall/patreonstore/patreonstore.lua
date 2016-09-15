temp = 0

talkLines = {	"Hi hi! Nice to see you!",
				"No, I'm not one of the figurines. They are over there.",
				"These are hand crafted with beautiful detail... by a machine.",
				"I sincerely appreciate all the support these people have given me. Thank you.",
				"Hey, you don't see any birds around here do you?",
				"What? I'm selling Blueprints in the mall? No I'm out here!"
}
function update(dt)

	temp = math.random(5)
	
	if temp == 1 then
		animator.setAnimationState("bodyState", "blink")
	elseif temp == 2 then
		animator.setAnimationState("bodyState", "twitch")
	elseif temp == 3 then
		animator.setAnimationState("bodyState", "stand")
	end
	
	temp = math.random(5)
	
	if temp < 3 then
		local people = world.entityQuery( object.position(), 20, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
		
		if #people > 0 then
			object.say( talkLines[ math.random( #talkLines ) ] )
		end
	end
end

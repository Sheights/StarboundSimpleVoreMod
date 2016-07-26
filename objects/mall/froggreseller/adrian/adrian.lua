temp = 0

talkLines = {	"I can't remember my last day off...",
				"Don't mind me, just working off my student loans.",
				"Trust me, I didn't choose any of this inventory.",
				"Please buy something. College isn't cheap...",
				"What's space like? Probably better than this.",
				"Tips would be really great right about now.",
				"Maybe today I'll finally make something of myself.",
				"At least this isn't the weirdest store here...",
				"I heard the last guy to work here went missing...",
				"Someday I'm getting off this rock... I hope.",
				"Uh, thanks for stopping by... (Guess it's ramen again tonight.)",
				"Come back anytime... Not like I'm going anywhere."
}
function update(dt)

	temp = math.random(5)
	
	if temp < 3 then
		animator.setAnimationState("bodyState", "anim")
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

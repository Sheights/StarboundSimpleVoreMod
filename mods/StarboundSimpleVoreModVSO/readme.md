# VSO Documentation

TODO

## VSO Overview

A VSO is a Starbound vehicle that can act like a monster, a npc, a container, a vehicle, and many other things.

It has the built in capability to track and manage multiple prey, as well as prevent them from escaping, play animations, do anything.

### Current working capabilities for VSO's are:

	1. Can grab/eat up to 8 NPC's / Players (starbound engine limitation with vehicles)
	2. Can play custom animations
	3. Can have layered animations (head, pody, parts)
	4. Can animate any grabbed/eaten npc's/players with .dance files
	5. Can change status effects on grabbed/eaten players at any time
	6. Can apply status effects
	7. Can look for item drops and take/eat them (Can eat items off the ground)
	8. Can remove items from players 
	9. Can kill npc's/players
	10. Can change player resources (energy, breath, health, etc)
	11. Can pop up dialogs on interaction
	12. Can pop up storefront on interaction
	13. Can pop up custom dialog with custom choices on interaction
	14. Can change to allow being attacked (for example, if one eats your friend, hit the VSO to free them)
	15. Can change what interactions do at any time
	16. Can search for target npc's/players
	17. Can pop up a say dialog to say short phrases
	18. Can play custom victim animations (you can pose the victim)
	19. Can spawn a VSO with the built in VSOAnimator tool to check animation data or make victim animations
	20. Can change properties per frame in an animation
	21. Can edit animation file so exact frame is known at time
	22. Can add directives to change color or more in a VSO
	23. Can apply custom masking to prey animations (to hide parts of prey during a victim animation)
	24. Can reinterpret incoming damage in any way you like (so a hit can always do at least 10% damage, for instance)
	25. Can play sounds defined in the animation file at any time
	26. Can be hand fed items if allowed (hold item, interact with VSO)
	27. Can create and drop items of any kind
	28. Can change motion abilities at any time (flying, ground motion, immovable)
	29. Can change damage team/ownership at any time
	30. Can grab/eat npc/players without them interacting (can nab them anytime)
	31. Can prevent eaten npcs/players from escaping
	32. Can read inputs from npcs/players once eaten, and respond accordingly
	33. Can block every input but teleport and E. They compensate for E by checking and reforcing a sit.
	34. Can optionally protect a eaten character from damage, or not by adjusting seat status
	35. Can toggle whether they are targeted by NPCS, and where the point to attack is (can be made hostile)
	36. Can alter what happens on vehicle death, either respawning, breaking the spawner, or smashing it forever
	37. Can pop up a custom dialog with custom options for conversations / choices.
	39. Can remember who they are or their previous state even after breaking, with a proper item script
	40. ... I'm forgetting some I'm sure (TELL US IDEAS)

### In progress capabilities for VSO's are:

	1. Move (red turtle), but movement has not been cleaned up or generalized yet
	2. Spawned as a monster, and behave as such
	3. Execute pathfinding like a NPC (partially working)
	4. Execute monster like pathfinding (partially working)
	5. Remember who they are or their previous state (load/save remembering you were eaten glitch) (partially working)
	6. Track a specific user/player (IE, if a specific player is nice to one, it should treat them different?) (partially working)
	7. Custom wiggle bar / status bar / resource bar display option (because fun gui options are fun?)
	8. Check targets inventory (can we see what items they have? Read maybe a configurable preference item?)
	9. Burp up remains/skulls/parts/gibs for fun (partially working)
	10. Lay an egg that can be broken apart for prizes?
	11. Sticky frog tongue to catch prey and pull them back? (partially working)
	12. ... I'm forgetting some I'm sure (TELL US IDEAS)
	
## SPOV Overview

A SPOV is a SPO like object (from the SSVM) that spawns a VSO. (SPO+VSO = SPOV)

This means, they behave like a SPO as in you place a object into the world, but they can do everything a VSO can.

### Current working capabilities for SPOV's are (in addition to VSO):

	1. Can store persistent memory between breaking
	2. Can customize their own tooltip and item icon on breaking
	3. Can be configured with the SPOV Enhancer and "pills", purchasable at bellybound, to toggle things like digestion
	4. Can have behaviour / "pills" changed by feeding certain items
	5. Can be killed / destroyed and either break the item or destroy it, or respawn. Like monsters or gauntlet!
	6. ... I'm forgetting some I'm sure

## Technical

VSO stands for "Vehicle Scripted Object" and is a general mod to add a ton of capabilities to a starbound vehicle.
Since vehicles operate as seats/chairs, and you can create up to 8 sitting positions on one,
We can THEN abuse the patch and message passing systems in starbound to create a loop.

player module can force sitting on certain chairs.
npc module has the same capability.
By adding message handlers to those, we can allow the VSO to give a status effect to targeted id's, that FORCES them to sit.

this was the foundation. After that, we added a ton of additional handers.
for instance, a vehicle cannot "say" things liek a monster.say can, so we have the VSO spawn a monster that can say for the VSO.
And, to place a VSO in the world (without a vehicle capture ball) we can place a object (a VSO spawner) that spawns the vehicle.
Because a OBJECT has permanence, and can store things, and act as a container, we can have the VSO communicate to the object like a base station.

This means a VSO spawned from a vso spawner has access to player, npc, object, vehicle, monster lua scripting options (everything, basically)
And it can communicate stored information as needed.

This opens up the use of the VSO's as pets, companions, defenders, interesting gameplay elements, challenges, and maybe even just vehicles.
I know it'd be amazing to have a robotic dinosaur you can ride that can EAT NPC's so that would be cool and fun in general...

Ultimately, the goal would be to seamlessly add a lore branch, maybe a few biome and planet types that require you to go out, get stuff, use that to buy new tools, equipment, and fun stuff like SPOV's, to an ultimate quest completion.
And it has to feel seamless to the starbound universe.

If enough work can be done to make the integration of something like these super monsters feel natural in the universe, then we'll know we've done it right.

Some major techinical hurdles had to be overcome to even make any of this possible of course.
Having to patch many lua files, adding many message handlers, finding undocumented functions and using them,
creating functions to remove formatting strings, adjust and check values,
customizeing gui controls, adding generators for many things, all of the usual state and entity tracking,
abstracting the querying and such.
It's a massive amount of work. (it's no frackin universe though)

Ideally, the VSO modification should be deployable as standalone so you could make whatever you wanted in any context (back to that giant rideable robo dino...)

In lua terms, there are a few tricks to get by.
Starbound correctly puts lua execution environments in sandboxes, so you can take advantage of _ENV to query what exists.
In this way, if you

function something()

end

then _ENV["something"] will be that function.

This makes it easy to make a simple, top level state machine that simply looks for those functions.

Additionally, in a node.js type of way, you can

vsoDoSomethingWithCallback( "delicious", function ( result )

	--hey we got result from a callback function!
end )

And do asynchronous operations. This is essential for saving storage, sending messages, adjusting resources and the like.
However it can incure a N frame delay so it is truly asynchronous.

The VSO system makes heavy use of these asynchronous operations.

Sometimes there is a bidirectional need and messages are sent back and forth as opposed to using the return value from a message call.


## Additional notes

	Unzipping the mod somtimes causes a folder problem, where there is an additional layer of folder. You have to move this up one to make the folder structure look correctly
	(add picture)
	Make sure to backup your player/universe stuff! Sometimes, mods (like FU) will break your players if other mods are used, but should work with a new player. Have not determined how to correct this.
	There is a large list of "FAQ" type questions we need to answer in a faq. Working on it, including a installation, spriting and how to tutorial which will probably start as a video.
	
*************************************************************
Unofficial Readme of the Unnoficial Starbound Simple Vore Mod
*************************************************************

Contents:
	1. Installation
	2. Accessing Content
		A. The Bellybound Store
		B. Placable Pred Objects
		C. Furniture
		D. NPC Predators
		E. NPC Prey
		F. RP Tool
	3. Contribution
	4. Ending
	
*************************************************************
1. Installation
*************************************************************

	Installation is no different with this mod than there is
	with any other. Simply copy and paste the folder
	containing everything to your mods directory which is
	located at: "steamapps\common\Starbound\giraffe_storage".
	The *.modinfo file must be at the root of the mod so that
	"mods\StarboundSimpleVore\StarboundSimpleVore.modinfo" is
	a valid path.
	
*************************************************************
2. Accessing Content
*************************************************************
	A. The Bellybound Store
	*********************************************************
	
	All content in this mod is accessable one way or another
	through our main form of distribution, the Bellybound
	Store. The store may be crafted by the player by pressing
	'c' to open up the player crafting menu and then
	selecting one of the two varients.
	
	The first is our original Bellybound store. It is quite
	bulky and large. The store is animated and has lines
	depending on the player's proximity. The second varient
	is the small holographic store. The holographic store
	takes up almost an imcomparable amount of space and has
	access to all the freatures the primary store has.
	
	*********************************************************
	B. Placable Predator Objects
	*********************************************************
	
	The placable predator objects were the first feature of
	the USSV. They are all purchasable from the Bellybound
	stores and come in a vast selection. The predators are
	organized by rarity and also some have tags. Static preds
	that consist of two frames, an empty and a full, are
	of 'common' rarity, which means they have a white border.
	Animated preds are 'uncommon' rarity and have a green
	border. When entering a pred they usually function as a
	bed healing the user, but preds with the keyword
	"Hungry" or preds with the tag [Digestion] will harm
	them. Animated preds with the [Digestion] tag will have
	special animations depending on the health of the user.
	Additional tags you can search for are: [CV]
	
	*********************************************************
	C. Furniture
	*********************************************************
	
	Bellybound also sells vore-themed furniture indicated by
	the purple border, or 'legendary' rarity. All of these
	objects do not specially interact with the player, but do
	carry a special 'tag' for the tenant system (See the next
	section for more information.) All furniture has every
	vore tag associated with it. So you can pick up that ugly
	badge after you spawn your tenant.
	
-----------------------------------------
| Item					| Cost			|
-----------------------------------------
| Badges				| 200 pixels	|
| Box of Condoms		| 100 pixels	|
| Consume: by Sheights	| 100 pixels	|
| Devourcraft Poster	| 100 pixels	|
| Dragon Sleeping Bag	| 150 pixels	|
| Emerald Vorb			| 2000 pixels	|
| Fed Mimic				| 1000 pixels	|
| Lamia Poster			| special		|
| Mimic					| 1000 pixels	|
| Ode de Endo			| 100 pixels	|
| Shark Tank			| 1000 pixels	|
| Slug Cage				| 1000 pixels	|
| Spit Roast			| 600 pixels	|
| Spooky Cauldron*		| 130 pixels	|
| Throne of Squish		| 95 pixels		|
| Tummy Tent			| 65 pixels		|
| Vorb					| 2000 pixels	|
-----------------------------------------
*Already available in the game. Just added the vore tags to it.
	
	*********************************************************
	D. NPCs
	*********************************************************
	
	For a complete list of tenants and required tags, check 
	'npcpredchart.png' in the root of this mod.
	For an indepth view of the base tenant system. Please
	read http://starbounder.org/Tenant
	
	The USSV mod offers a unique form of content in NPCs
	and tenants. Each of our special tenants has the
	unique ability to seemingly consume the player and other
	NPCs around them. 
	
	Spawning: To summon one of these NPCs you need to build
	them a room. The room must be an enclosed environment
	including background. Fill the room with the furniture
	required to summon the particular tenant. Try to match the
	requirements without going too far over the required tags,
	you can add more furniture later. After your house is
	filled with furniture, purchase and place the badge(s) for
	the type of action you want your NPC to perform.
	
		For oral vore, place down a V badge.
		For fatal oral vore, place down a D badge.
		For unbirth, place down a V badge. (Will be changed later)
		For cock vore, place down a C badge and a V badge.
		For fatal cock vore, place down a C badge and a D badge.
		The P badge is for the prey system mentioned down below.
		
	Now that your house is full of furniture and has the
	appropriate spawning badge, place down a 'Colony Deed' or
	a 'Compact Deed'. You may buy both of these at either
	Bellybound or Frogg Furninshings. If everything is done
	correctly, your tenant will appear. At this point you may
	put down any other piece of furniture from Bellybound and
	pick up the badge. You may also wish to add more furniture
	to the home. Make sure you arn't removing any required tags
	what would reduce the total less than the required amount.
	
	Features: NPCs will attempt to eat the player and other NPCs
	periodically. When eaten you will be incitated for 90-120
	seconds depending on the type of predator. While eaten you
	can not move. NPCs will go about their day with you as
	their unwilling companion.
	
	You may also interact with our NPCs by pressing 'e' twice
	quickly. This will allow you to "request" to be eaten.
	In this state you may stay as long as you want. For UB
	preds, you will only be stuck in an egg if you stay
	for atleast the normal duration of the non-forced
	version. You will digest at the normal rate for fatal
	NPCs. To leave an NPC, requested or no, interact twice
	quickly again. This will make any normal NPC void them
	selves of their prey (even if you arn't it) but preds
	with increased capacity require you to to actually be
	one of their victims.
	
	NPCs include a few configuration options that can be made
	by viewing "/scripts/vore/npcvore.lua" or
	"/scripts/vore/multivore.lua". You may open .lua files
	with any text editor like Notepad. Lua files are what are
	called "scripts" and don't need to be compiled. The
	config sections are defined clearly at the top as well as
	what values are appropriate. Change the value to fit your
	needs and save the document to apply changes.
	
	Under normal circumstances predators will not eat players
	located on a player ship. Players are invincible on their
	ships to prevent griefing. If you wish to take a starry
	flight from the comfort of your favorite belly you must
	disable this invincibility. You are able to do this in
	both config sections. The option is disabled by default.
	Enabling this option and summoning an NPC to your ship
	will disable all player invincibility on that particular
	ship until you set it back. I will not provide a method
	of doing this, as it can be used to make entire planets
	sanctuary.
	
	*********************************************************
	F. NPC prey.
	*********************************************************
	
	Prey are avaiable in a similar fashion to NPC predators.
	To summon a prey you use the P badge instead of other
	badges. Use a P and a D badge to spawn an NPC you will
	digest. Prey spaw with a random personality or "profile".
	A prey's profile will evolve the more times you eat them.
	Some prey may enjoy being eaten, some may fear it, and
	even some may dislike it at first but grow to love it.
	
	When a prey is spawned double press 'e' to eat them.
	You won't get a belly, so improvise. While eaten prey
	will most likely grovel for their lives(or thank you).
	If you spawn a digest prey, they may try to trade their
	money for their life. Release a prey after they attempt
	bribe you and they will pay you.
	
	There are 6 kinds of prey and 3 profiles right now. One
	for each race minus Novakids. A prey tenant can be
	summoned with just a door, light, and a badge, but if you
	also include 6 of the respective racial tag, you can
	control which race spawns.
	
	*********************************************************
	F. RP Tool
	*********************************************************
	
	Avaiable at the bellybound store is a "Vore Tech Chip".
	Buying it will enable a tech you may select at your
	ship's AI center. This tech is centered around the prey
	for role playing. Place your cursor over your potential
	player pred and press F. You will turn invisible and
	follow the subject. Press F again to return. There are
	no bellies or sounds currently. You may improvise with
	assets found in the mod or make your own. Check the
	contributions section for more help on the matter.
	(I havn't written it yet but whatever.)
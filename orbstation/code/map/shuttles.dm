// Emergency shuttles

/datum/map_template/shuttle/emergency/orb
	suffix = "orb"
	name = "Orb Emergency Shuttle"
	description = "The ultimate vessel for any and all fans of 'Orb', the OES houses everything one needs to escape in saftey. It is powered by everyone who believes in the ORB."
	credit_cost = 7999

// Emag shuttles

/datum/map_template/shuttle/emergency/zetan_bc
	suffix = "zetan_bc"
	name = "Zetan Battle Cruiser"
	description = "The ultimate weapon of the Zetan armada, with an elite Zetan Bouncer guard deployed 24/7. The shuttle and the bouncer can both do karate."
	credit_cost = CARGO_CRATE_VALUE * 10
	emag_only = TRUE

/datum/map_template/shuttle/emergency/orbescape
	suffix = "orbescape"
	name = "OES Escape Shuttle"
	description = "The secret feature of the Orb Emergency Shuttle, the bridge that can detach in case of dire emergencies. It would be unfortunate if it was the main escape route for an entire station."
	credit_cost = CARGO_CRATE_VALUE * 5
	emag_only = TRUE
	admin_notes = "this things tiny as fuck"
/datum/map_template/shuttle/emergency/maintshuttle
	suffix = "maintshuttle"
	name = "Maintenance Tsars Pleasure Barge"
	description = "The grand pleasure barge of the Maintenance Tsar, loaded with Cheese, drink, and the Maintenance Tsar themself. It is not compliant with Space OSHA standards."
	credit_cost = CARGO_CRATE_VALUE * 7
	emag_only = TRUE

// Other shuttles

/datum/map_template/shuttle/pirate/zetan
	suffix = "zetan"
	name = "pirate ship (ZETAWEST ENFORCERS)"

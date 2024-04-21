extends Label

"""

Show the stats in top right left corner of the screen. Actually quite expensive on performance because of some function calls it does. 

"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var message = ""

	# get_total_energy is quite expensive, should not be called this offten when not debuging
	message += "Total Energy: " + str(int(EnergyManager.get_total_energy())) + " (" + str(int(EnergyManager.lostEnergy)) + ")" + "\n"
	message += "Entities: " + str(EnergyManager.get_total_entities())
	message += " (C: " + str(EnergyManager.creatures.size()) 
	message += " P: " + str(EnergyManager.plants.size())
	message += " S: " + str(EnergyManager.seeds.size()) + ")\n"
	message += "FPS: " + str(Engine.get_frames_per_second())
	message += " (Speed " + str(Engine.time_scale) + "x)\n"
	message += "Highest Generation P: " + str(EnergyManager.max_plant_generation) + " C: " + str(EnergyManager.max_creature_generation)


	text = message

	pass

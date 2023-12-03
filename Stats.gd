extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var message = ""

	message += "Total Energy: " + str(int(EnergyManager.get_total_energy())) + " (" + str(int(EnergyManager.lostEnergy)) + ")" + "\n"
	message += "Entities :" + str(EnergyManager.get_total_entities()) + "\n"
	message += "FPS: " + str(Engine.get_frames_per_second()) + "\n"


	text = message

	pass

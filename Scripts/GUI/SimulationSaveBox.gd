extends Control


"""

This is attached to the SimulationSaveBox scene. It is GUI element to show saved simulations and to allow the user to pick one to load or delete.

"""

signal load(path)
signal delete(path)


func _on_load_pressed():
	load.emit($HBoxContainer/Name.text)

func _on_delete_pressed():
	delete.emit($HBoxContainer/Name.text)

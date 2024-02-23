extends Control


func _on_new_simulation_pressed():
	
	$VBoxContainer.visible = false
	$"New Simulation Menu".visible = true
	
	pass # Replace with function body.


func _on_start_new_simulation_pressed():
	
	var data = load("res://main.tscn") as PackedScene
	var new_simulation = data.instantiate()
	
	new_simulation.get_node("SaveManager").save_path = "res://test.tres"
	
	queue_free()
	get_tree().root.add_child(new_simulation)
	
	new_simulation.get_node("SaveManager").load()
	
	pass # Replace with function body.


func _on_load_simulation_pressed():
	
	$VBoxContainer.visible = false
	$"Load Simulation Menu".visible = true
	
	pass # Replace with function body.

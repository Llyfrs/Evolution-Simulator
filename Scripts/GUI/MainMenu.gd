extends Control

"""
Just lost of showing and hiding GUI elements based on the user actions. Only makes sense in the context of GUI in the godot editor.
"""

var data_collection : bool = false

func _ready():
	
	## Ensurs the tree is running
	get_tree().paused = false
	
	if not DirAccess.dir_exists_absolute("user://Saves"):
		DirAccess.make_dir_absolute("user://Saves")


func _on_new_simulation_pressed():
	
	$VBoxContainer.visible = false
	$"New Simulation Menu".visible = true
	
	pass # Replace with function body.


func to_snake_case(text):
	var result = text  # Convert to lowercase
	result = result.replace(" ", "_")  # Replace spaces with underscores
	
	return result
	
func _show_error(message):
	$"New Simulation Menu/Error".text = message
	$"New Simulation Menu/Error".visible = true
	

func _on_start_new_simulation_pressed():

	var path_text = $"New Simulation Menu/GridContainer/SavePath".text as String
	
	if path_text == "" or !path_text.is_valid_filename():
		_show_error("Ivalid file name")
		return
		
	path_text = "user://Saves/" + path_text + ".tres"

	if FileAccess.file_exists(path_text):
		_show_error("Simulation already exists")
		return
	
	var empty_save = SimulationSave.new()

	empty_save.data_collection = data_collection
	
	ResourceSaver.save(empty_save, path_text)
	
	start_simulation(path_text)

	
func start_simulation(path : String):
	
	path = "user://Saves/" + path + ".tres"

	var new_simulation = Globals.simulation.instantiate()
	
	new_simulation.get_node("SaveManager").save_path = path
	
	get_tree().root.add_child(new_simulation)

	new_simulation.get_node("SaveManager").load()
	new_simulation.get_node("SaveManager")._ready()
	
	queue_free()


func delete_simulation(path : String):
	
	path = path + ".tres"
	var dir = DirAccess.open("user://Saves")

	
	dir.remove(path)
	_on_load_simulation_pressed()
	
	pass

func _on_load_simulation_pressed():
	
	
	$VBoxContainer.visible = false
	$"Load Simulation Menu".visible = true
	
	var list = $"Load Simulation Menu/Panel/ScrollContainer/List"
	
	for child in list.get_children():
		
		if child.name != "Label" and child.name != "ColorRect":
			list.remove_child(child)
			child.queue_free()
	
	for file in DirAccess.get_files_at("user://Saves"):
		
		if file.ends_with(".tres"):
			
			file = file.trim_suffix(".tres")
			
			var box = Globals.SaveBox.instantiate()
			box.get_node("HBoxContainer/Name").text = file
			
			box.load.connect(start_simulation)
			box.delete.connect(delete_simulation)
			
			list.add_child(box)

	
	pass # Replace with function body.


func _on_return_pressed():
	$"New Simulation Menu".visible = false
	$"Load Simulation Menu".visible = false
	$Credits.visible = false
	$VBoxContainer.visible = true


func _on_credits_pressed():
	$Credits.visible = true
	$VBoxContainer.visible = false
	

func _on_data_collection_toggled(toggled_on):
	data_collection = toggled_on

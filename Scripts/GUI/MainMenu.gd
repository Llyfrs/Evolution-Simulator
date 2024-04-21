extends Control

"""
Just lost of showing and hiding GUI elements based on the user actions. Only makes sense in the context of the godot editor.

"""

func _ready():
	if not DirAccess.dir_exists_absolute("user://Saves"):
		DirAccess.make_dir_absolute("user://Saves")


func _on_new_simulation_pressed():
	
	$VBoxContainer.visible = false
	$"New Simulation Menu".visible = true
	
	pass # Replace with function body.


func to_snake_case(text):
	var result = text.to_lower()  # Convert to lowercase
	result = result.replace(" ", "_")  # Replace spaces with underscores
	return result

func _on_start_new_simulation_pressed():
	
	var path_text = $"New Simulation Menu/SavePath".text
	
	if path_text == "":
		print_debug("Empty Simulation Name")
		return

	
	path_text = "user://Saves/" + to_snake_case(path_text) + ".tres"
	
	if FileAccess.file_exists(path_text):
		print_debug("File aready exists")
		return
	
	var empty_save = SimulationSave.new()
	ResourceSaver.save(empty_save, path_text)
	
	start_simulation(path_text)

	


func start_simulation(path : String):
	
	var data = load("res://Scenes/Maps/main.tscn") as PackedScene
	var new_simulation = data.instantiate()
	
	new_simulation.get_node("SaveManager").save_path = path
	
	queue_free()
	get_tree().root.add_child(new_simulation)
	
	new_simulation.get_node("SaveManager").load()

func _on_load_simulation_pressed():
	
	$VBoxContainer.visible = false
	$"Load Simulation Menu".visible = true
	
	var list = $"Load Simulation Menu/FileList" as ItemList
	
	for file in DirAccess.get_files_at("user://Saves"):
		
		if file.ends_with(".tres"):
			list.add_item(file)
	
	
	pass # Replace with function body.


func _on_start_pressed():
	
	var list = $"Load Simulation Menu/FileList" as ItemList
	var indx = list.get_selected_items()[0]
	
	start_simulation("user://Saves/" + list.get_item_text(indx))

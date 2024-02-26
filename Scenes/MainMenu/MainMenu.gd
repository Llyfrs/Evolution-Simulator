extends Control


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
	var err = ResourceSaver.save(empty_save, path_text)
	
	print(err)
	
	var data = load("res://main.tscn") as PackedScene
	var new_simulation = data.instantiate()
	
	new_simulation.get_node("SaveManager").save_path = path_text
	
	queue_free()
	get_tree().root.add_child(new_simulation)
	
	new_simulation.get_node("SaveManager").load()
	
	pass # Replace with function body.


func _on_load_simulation_pressed():
	
	$VBoxContainer.visible = false
	$"Load Simulation Menu".visible = true
	
	var list = $"Load Simulation Menu/FileList" as ItemList
	
	for file in DirAccess.get_files_at("user://Saves"):
		list.add_item(file)
	
	
	pass # Replace with function body.

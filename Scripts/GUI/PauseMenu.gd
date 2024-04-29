extends Control


"""

When user presses the escape key, the game will pause and the pause menu will appear.
This script will handle the pause menu's functionality. Including returning to the main menu.

"""


var main_menu = preload("res://Scenes/MainMenu/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	get_tree().paused = false
	visible = false


func _on_save_pressed():
	get_tree().paused = false
	Globals.save_manager.save()
	get_tree().paused = true


func _on_save__exit_button_up():
	_on_save_pressed()
	get_tree().root.add_child(main_menu.instantiate())
	
	## Ugly yes, but something isn't working right with the chance_scene_to_packed function unfromtunately 
	get_parent().get_parent().queue_free()
	
	get_tree_string_pretty()
	
	

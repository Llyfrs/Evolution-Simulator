extends Control

"""

When saving creature or plant, this popup will appear to ask for the name of the creature or plant.
It freezes the game while it is visible. And returns the name of the creature or plant when the save button is pressed.

"""


signal result(name : String)

func _ready():
	hide()

func _on_cancel_pressed():
	result.emit("")
	_reset()
	pass # Replace with function body.

func _on_save_pressed():
	
	if $Panel/VBoxContainer/LineEdit.text == "": ## This shows error message if the name is empty
		$Panel/VBoxContainer/HBoxContainer/Label.visible = true
		return
	
	result.emit($Panel/VBoxContainer/LineEdit.text)
	
	_reset()

	pass # Replace with function body.


func _reset():
	$Panel/VBoxContainer/LineEdit.text = ""
	$Panel/VBoxContainer/HBoxContainer/Label.visible = false
	visible = false
	get_tree().paused = false
	

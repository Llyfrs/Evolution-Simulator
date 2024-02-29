extends Control

func _on_select_pressed():
	Globals.cursor = Globals.CursorMode.SELECT
	pass # Replace with function body.


func _on_paint_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	pass # Replace with function body.


func _on_plant_pressed():
	Globals.cursor = Globals.CursorMode.PLANT
	pass # Replace with function body.


func _on_creature_pressed():
	Globals.cursor = Globals.CursorMode.CREATURE
	pass # Replace with function body.

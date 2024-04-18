extends Label




func _on_min_plants_value_changed(value):
	text = str(value)
	Globals.min_plants = value
	pass # Replace with function body.



func _on_min_creatures_value_changed(value):
	text = str(value)
	Globals.min_creatures = value
	pass # Replace with function body.

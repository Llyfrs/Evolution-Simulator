extends Label


"""

This script is attached ot the min sliders in tool window. It just makes sure to update it's text accordingly, and update the global variables in Globals.gd

"""

func _on_min_plants_value_changed(value):
	text = str(value)
	Globals.min_plants = value
	pass # Replace with function body.



func _on_min_creatures_value_changed(value):
	text = str(value)
	Globals.min_creatures = value
	pass # Replace with function body.

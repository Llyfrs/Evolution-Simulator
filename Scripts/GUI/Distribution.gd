extends VBoxContainer


func _ready():
	$Sand/Slider.value  = EnergyManager.redistribution[Globals.Tile.SAND]
	$Grass/Slider.value = EnergyManager.redistribution[Globals.Tile.GRASS]
	$Stone/Slider.value = EnergyManager.redistribution[Globals.Tile.STONE]
	$Water/Slider.value = EnergyManager.redistribution[Globals.Tile.WATER]

func _on_grass_value_changed(value):
	EnergyManager.redistribution[Globals.Tile.GRASS] = value
	pass # Replace with function body.


func _on_stone_value_changed(value):
	EnergyManager.redistribution[Globals.Tile.STONE] = value
	pass # Replace with function body.


func _on_water_value_changed(value):
	EnergyManager.redistribution[Globals.Tile.WATER] = value
	pass # Replace with function body.


func _on_sand_value_changed(value):
	EnergyManager.redistribution[Globals.Tile.SAND] = value
	pass # Replace with function body.

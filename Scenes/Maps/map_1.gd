extends Node2D

var energy = Dictionary()


func get_energy(position :Vector2) -> int:
	
	var tile = energy.get(position)
	
	if tile != null:
		return tile
	else:
		energy[position] = 40
		return 40
	
	pass

func set_energy(position : Vector2, value : int):
	energy[position] = value
	pass


func _ready():
	print("map")

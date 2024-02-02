extends RigidBody2D
class_name Seed

@export var map : TileMap 
@export var rootMap : TileMap

var dna : PlantDNA = null
var energy : float

var plant_scene = preload("res://Scenes/Plants/plant.tscn")
var food_texture = preload("res://Textures/food.png")

	
func remove_energy(value: float):
	var leftover = 0 
	
	if energy > value: 
		energy -= value
	else:
		leftover = value - energy
		energy = 0
		root()
		
	return leftover


func get_tile():
	var local = map.to_local(global_position)
	return map.local_to_map(local)

func root():
	if dna != null:
		var plant = plant_scene.instantiate() as Plant
		## Carefull we are getting freed so the plant needs to go to our parrents

		plant.set_dna(dna)
		plant.map = map
		plant.rootMap = rootMap
		
		plant.global_position = self.global_position
		
		get_parent().add_child(plant)
		plant.owner = get_parent()
	
	EnergyManager.add_lost_energy(energy)
	EnergyManager.unsubscribe(self)
	queue_free()
	
	pass
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	EnergyManager.subscribe(self)

	
	if dna == null:
		$Texture.texture = food_texture
		scale = Vector2(0.3,0.3)
		$Texture.scale = scale



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var l_position = map.local_to_map(map.to_local(global_position))
	
	var data = map.get_cell_atlas_coords(0, l_position)
	
	# Delete your self if outside the map
	if data == null or data == Vector2i(18,1):
		EnergyManager.add_lost_energy(energy)
		EnergyManager.unsubscribe(self)
		queue_free()
	
	pass

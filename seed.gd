extends RigidBody2D
class_name Seed

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
	var local = Globals.mainMap.to_local(global_position)
	return Globals.mainMap.local_to_map(local)

func root():
	
	if dna != null and not EnergyManager.is_limited(Limits.PLANT):
		get_parent().call_deferred("root_seed", dna, global_position)
	
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


var acumulator = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	acumulator += delta
	
	if acumulator < 1:
		return
		
	delta = acumulator
	acumulator = 0
	
	# var l_position = Globals.mainMap.local_to_map(Globals.mainMap.to_local(global_position))
	# var data = Globals.mainMap.get_cell_atlas_coords(0, l_position)
	
	# # Delete your self if outside the map
	# if data == null or data == Globals.WALL_TILE:
	# 	EnergyManager.add_lost_energy(energy)
	# 	EnergyManager.unsubscribe(self)
	# 	queue_free()

	# Decomposes itself over time on to the tile it is on
	# For food this is way to give energy to plants 
	# For seeds this is way to root 
	
	
	var degrade = 5 * delta
	var leftover = remove_energy(degrade)
	EnergyManager.add_energy(get_tile(), degrade - leftover)
	
	
	
	pass


func save() -> SeedSave:
	var sv = SeedSave.new()

	sv.file_path = scene_file_path

	sv.dna = dna
	sv.energy = energy
	sv.pos = global_position
	sv.lin_vel = linear_velocity

	return sv

func load(sv : SeedSave):

	## Duplicate prevents circular referencing of a resources
	dna = null if sv.dna == null else sv.dna.duplicate()
	energy = sv.energy
	linear_velocity = sv.lin_vel
	global_position = sv.pos


func _exit_tree():
	EnergyManager.unsubscribe(self)



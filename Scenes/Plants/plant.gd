class_name Plant
extends Node2D

var root : Root
var dna  : PlantDNA

var energy : float
var health : float

var can_grow := true

var seed_sceen = preload("res://seed.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	root = $Root as Root
	
	if dna == null:
		dna = PlantDNA.new()
		$PlantSmall.set_modulate(dna.color)


	EnergyManager.subscribe(self)
	pass 


func set_dna(plantDNA: PlantDNA):
	dna = plantDNA
	$PlantSmall.set_modulate(dna.color)
	


## Adds vlaue to current energy and returns all the left over energy
## or returns 0 if the energy didn't overflown
func add_energy(value : float) -> float:
	var leftover = 0
	
	# Manages adding energy to the plant
	# If the energy is overflown it returns the difference
	energy += value
	if energy > dna.energy:
		leftover = energy - dna.energy
		energy = dna.energy
	

	# Manages growing roots
	var root_grow_cost: float = 5 * dna.root_effectivnes
	if energy > dna.root_grow_threshold and energy >= root_grow_cost and can_grow:
		var result: int = root.grow(dna)
		if result > 0: 
			energy -= root_grow_cost
			EnergyManager.add_lost_energy(root_grow_cost)
		elif result < 0:
			can_grow = false
	
	return leftover


## Substracts current energy by value
## If there is less energy that it's called to be removed
## it returns by how much was the difference
func sub_energy(value: float) -> float:
	var leftover = 0
	energy -= value
	if energy < 0:
		leftover = energy
		energy = 0
	
	
	return leftover

func add_health(value : float) -> float: 
	health += value
	var leftover = max(health - dna.health, 0)
	health = min(health, dna.health)
	
	if health == dna.health:
		reproduce()
	
	return leftover
	
	
func sub_health(value: float) -> float: 
	health -= value
	var leftover = min(health, 0)
	health = max(health,0)
	return leftover

func reproduce():
	var cost = dna.seed_nutrition * dna.seed_quantity
	
	#print("With: " + str(dna.seed_nutrition)+ " " + str(dna.seed_quantity))
	#print("We have cost of: " + str(cost))
	
	var n = 0

	
	if cost <= health:
		health -= cost
		n = dna.seed_quantity
	else: 
		n = floori(health / dna.seed_nutrition)
		health -= n * dna.seed_nutrition
		EnergyManager.add_lost_energy(health)
		health = 0

	
	
	for i in range(n):
		@warning_ignore("shadowed_global_identifier")
		var seed = seed_sceen.instantiate() as Seed
		seed.energy = dna.seed_nutrition
		seed.global_position = global_position
		seed.dna = dna.mutate(0.4, 0.4)

		var direction = Vector2(1, 0)
		
		direction = direction.rotated(dna.seed_direction + randf_range(-dna.seed_spread, dna.seed_spread))
				
		seed.linear_velocity = direction * randi_range(30, 100)
		
		#seed.global_position = Vector2i(global_position.x + randi_range(-50, 50), global_position.y + randi_range(-50, 50))
		get_parent().add_child(seed)
		

func die():
	
	var sd: Seed = seed_sceen.instantiate() as Seed
	sd.energy = health + energy 
	sd.global_position = global_position
	
	## Hopefully this saves some performance, we don't need the food to move
	sd.set_physics_process(false)
	get_parent().add_child(sd)
	
	# print(self.name + ": Died" )
	EnergyManager.unsubscribe(self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	## Handles growing / health adding 
	var grow_value      = dna.plant_grow_speed * delta
	var leftover: float = -sub_energy(grow_value)
	
	if leftover > 0: 
		grow_value -= leftover

	
	leftover = add_health(grow_value)
	add_energy(leftover)

	if energy <= 0 or health <= 0:
		die()


	## Energy unlike health is mannaged in the EnergyManager

	$Panel/Energy.text = "Energy: " + str(int(energy)) + "/" + str(dna.energy)
	$Panel/Health.text = "Health: " + str(int(health)) + "/" + str(dna.health)
	#energy -= delta * 1
	pass


func _on_area_2d_mouse_entered():
	$Panel.visible=true
	root.highlight_owned_roots(true)
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	$Panel.visible=false
	root.highlight_owned_roots(false)
	pass # Replace with function body.



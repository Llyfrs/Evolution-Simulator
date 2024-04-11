class_name Creature extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var seed_sceen = preload("res://Scenes/Plants/seed.tscn") as PackedScene

var dna : CreatureDNA

var energy : float
var health : float



var is_immortal : bool = true

enum Influence {
	ROTATE_LEFT,
	ROTATE_RIGHT,
	MOVE_FORWARD,
	MOVE_BACKWARDS,
	PAUSE_REPRODUCTION,
	PAUSE_ATTACKING, 
}


## Needs to be float to work over 60 frames per second for example
var influence : Array[float]

## Plants and Creatures that are in the mouth range
var targets : Array


func _ready():
	influence.resize(Influence.size())

	for i in range(Creature.Influence.size()):
		influence[i] = randi_range(0, 200)
	


	## For in editor placed Creatures
	if dna == null:
		dna = CreatureDNA.new()
		energy =  dna.energy
		health = dna.health

	modulate = dna.color
	
	for sensor in dna.sensors:
		var child = Sensor.new()
		child.conf = sensor
		child.detection.connect(add_influence)
		$Sensors.add_child(child)

	EnergyManager.subscribe(self)

		
		
	


func _process(delta):


	# Needs to be caculated on tile type
	var speed = dna.speed

	var rspeed = dna.rotation_speed
	
	# Forward and backward influence handling
	var fw : float = influence[Influence.MOVE_FORWARD]
	var bw : float = influence[Influence.MOVE_BACKWARDS]
	

	if min(fw, bw) == 0:
		velocity = Vector2(0, sign(bw - fw) * speed)
	else:
		var strg = (1 - min(fw, bw) / max(fw, bw))
		velocity = Vector2(0, sign(bw - fw) * (speed * strg))

	
	
	# Rotate Influence Handling
	var rl : float = influence[Influence.ROTATE_LEFT]
	var rr : float = influence[Influence.ROTATE_RIGHT]

	if min(rl, rr) == 0:
		rotate( deg_to_rad(rspeed * sign(rr - rl) * delta))
	else:
		var strg = (1 - min(rr, rl) / max(rr, rl))
		rotate( deg_to_rad( strg * rspeed * sign(rr - rl) * delta))


	# Reproduction
	
	if health == dna.health and influence[Influence.PAUSE_REPRODUCTION] == 0:
		reproduce()


	# Energy 

	
	var used_energy =  (pow(velocity.length(), 2) * 0.0005) * delta

	#print("Traveling cost" + str(used_energy) )

	used_energy += dna.proficiency_tax() * delta
	used_energy += dna.sensor_tax() * delta
	
	
	used_energy = used_energy / 10

	#print("Using: " + str(used_energy) + " From: " + str(energy))
	
	var leftover = sub_energy(used_energy) 
	if leftover != 0 or energy <= 0:
		die()

	# Rotating velocity so we are moving in the direction we are facing
	# this would not work if the velocity would not be set every frame anew, but it is.
	velocity = velocity.rotated(rotation)
	
	# Aply speed modifier based on the best possible tile
	var terrain = Globals.get_tile_type(get_current_tile())
	var best = 0
	for type in terrain:
		best = max(best, dna.tile_efficiency[type])
	
	
	
	velocity *= best
	
	
	grow(delta)
	influence_decay(delta)
	attack(delta)
	
	if not velocity.is_zero_approx():
		move_and_slide()
	
	pass 


func eat(body: Node2D):

	body = body as Seed

	if body.dna != null and body.dna.seed_durability > dna.bite_strength:
		return
	
	
	var leftover = add_energy(body.energy)
	
	if leftover == 0:
		body.queue_free()
	else:
		body.energy = leftover

# Not my proudest pice of code
func attack(delta):

	if influence[Influence.PAUSE_ATTACKING] != 0:
		return

	for target in targets:
		if "take_damage" in target:
			target.take_damage(dna.bite_strength * delta)
		elif "take_damage" in target.get_parent():
			target.get_parent().take_damage(dna.bite_strength * delta)
			
func grow(delta):
	var growth = dna.growth_speed * delta 
	
	if energy > growth:
		health += growth
		if health > dna.health:
			energy += health - dna.health
			health = dna.health
		energy -= growth

func start_attacking(body):
	targets.append(body)
	pass

func stop_attacking(body):
	targets.erase(body)
	pass


func die():
	
	if is_immortal:
		return  

	var sd: Seed = seed_sceen.instantiate() as Seed
	sd.energy = health + energy 
	sd.global_position = global_position
	
	## Hopefully this saves some performance, we don't need the food to move
	get_parent().add_child(sd)
	
	# print(self.name + ": Died" )
	EnergyManager.unsubscribe(self)
	queue_free()
	
	pass


func reproduce():

	for i in range(dna.offsprings):

		if dna.offspring_energy > health or EnergyManager.is_limited(Limits.CREATURE):
			break

		health -= dna.offspring_energy

		var offspring = Globals.creature_scene.instantiate() as Creature


		offspring.energy = dna.offspring_energy
		offspring.dna = dna.mutate(0.4, 0.4)

		offspring.global_position = global_position

		get_parent().add_child(offspring)

	pass


## Adds value to current energy and returns all the left over energy
## or returns 0 if the energy didn't overflown
func add_energy(value : float) -> float:
	var leftover = 0
	
	# Manages adding energy to the creature
	# If the energy is overflown it returns the difference
	energy += value
	if energy > dna.energy:
		leftover = energy - dna.energy
		energy = dna.energy
	

	return leftover


func sub_energy(value : float):
	var leftover = 0
	energy -= value
	if energy < 0:
		leftover = energy
		energy = 0
	
	EnergyManager.add_lost_energy(value - leftover)

	return leftover


func add_influence(inf_value : float, inf_type : Creature.Influence):
	influence[inf_type] += inf_value
	pass

func influence_decay(delta):
	for i in range(Influence.size()):
		influence[i] = max(0,  influence[i] - dna.influence_decay[i] * delta)


func get_data() -> CreatureData:
	var data = CreatureData.new()

	data.energy = energy
	data.health = health

	return data

func save() -> CreatureSave:

	var sv = CreatureSave.new()

	sv.file_path = scene_file_path

	sv.dna = dna

	sv.energy = energy
	sv.health = health

	sv.pos = global_position
	sv.rot = rotation
	sv.vel = velocity

	sv.influence = influence.duplicate()

	return sv


func load(sv : CreatureSave):
	
	dna = sv.dna

	energy = sv.energy
	health = sv.health
	velocity = sv.vel

	global_position = sv.pos
	rotation = sv.rot

	influence = sv.influence.duplicate()



func _on_mouse_entered():
	Globals.selected.append(self)
	pass # Replace with function body.


func _on_mouse_exited():
	Globals.selected.erase(self)
	pass # Replace with function body.


func _on_tree_exiting():
	Globals.selected.erase(self)
	EnergyManager.unsubscribe(self)
	pass # Replace with function body.


func _on_mortality_timeout():
	is_immortal = false
	pass # Replace with function body.

func get_current_tile():
	return Globals.mainMap.local_to_map(Globals.mainMap.to_local(global_position))
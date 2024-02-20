class_name Creature extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dna : CreatureDNA

var energy : float
var health : float

enum Influence {
	ROTATE_LEFT,
	ROTATE_RIGHT,
	MOVE_FORWARD,
	MOVE_BACKWARDS,
	REPRODUCE
}


## Need to be float to work over 60 frames per second for example
var influence : Array[float]




func _ready():
	influence.resize(Influence.size())

	for i in range(Creature.Influence.size()):
		influence[i] = randi_range(0, 20)

	dna = CreatureDNA.new()

	energy = randi_range(0, dna.energy)
	health = randi_range(0, dna.health)


	
	for sensor in dna.sensors:
		var child = Sensor.new()
		child.conf = sensor
		child.detection.connect(add_influence)
		$Sensors.add_child(child)

		print("adding sensor")

		
		
	


func _process(delta):

	# Needs to be caculated on tile type
	var speed = 200

	var rspeed = 30
	
	# Forward and backward influence handling
	var fw : float = influence[Influence.MOVE_FORWARD]
	var bw : float = influence[Influence.MOVE_BACKWARDS]
	

	if min(fw, bw) == 0:
		velocity = Vector2(0, sign(fw - bw) * speed)
	else:
		var strg = (1 - min(fw, bw) / max(fw, bw))
		velocity = Vector2(0, sign(fw - bw) * (speed * strg))

	
	
	# Rotate Influence Handling
	var rl : float = influence[Influence.ROTATE_LEFT]
	var rr : float = influence[Influence.ROTATE_RIGHT]

	if min(rl, rr) == 0:
		rotate( deg_to_rad(rspeed * sign(rr - rl) * delta))
	else:
		var strg = (1 - min(rr, rl) / max(rr, rl))
		rotate( deg_to_rad( strg * rspeed * sign(rr - rl) * delta))


	# Reproduction
	

	

	# Rotating velocity so we are moving in the direction we are facing
	# this would not work if the velocity would not be set every frame anew, but it is.
	velocity = velocity.rotated(rotation)

	influence_decay(delta)
	move_and_slide()
	pass 





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

	var save = CreatureSave.new()

	return save


class_name Creature extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dna : CreatureDNA



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


	
	for sensor in dna.sensors:
		var child = Sensor.new()
		child.conf = sensor
		child.detection.connect(add_influence)
		$Sensors.add_child(child)

		print("adding sensor")

		
		
	


func _process(delta):

	## Needs to be caculated on tile type
	var speed = 200
	
	## Float so we can calculate the strength
	var fw : float = influence[Influence.MOVE_FORWARD]
	var bw : float = influence[Influence.MOVE_BACKWARDS]
	

	if min(fw, bw) == 0:
		velocity = Vector2(0, sign(fw - bw) * speed)
	elif fw > bw:
		var str = (1 - bw / fw)
		velocity = Vector2(0, -1) * (speed * str)
	elif fw < bw:
		var str = (1 - fw / bw)
		velocity = Vector2(0, 1) * (speed * str)
		


	
	influence_decay(delta)
	move_and_slide()
	pass 





func add_influence(inf_value : float, inf_type : Creature.Influence):
	influence[inf_type] += inf_value
	pass



func influence_decay(delta):
	for i in range(Influence.size()):
		influence[i] = max(0,  influence[i] - dna.influence_decay[i] * delta)
	



func save() -> CreatureSave:

	var save = CreatureSave.new()

	return save


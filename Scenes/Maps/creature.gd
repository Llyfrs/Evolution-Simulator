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


var influence : Array




func _ready():
	influence.resize(Influence.size())
	influence.fill(0)

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
	

	if fw == 0 and bw == 0:
		velocity = Vector2(0,0)
	elif fw == 0 and bw != 0:
		velocity = Vector2(0, 1) * speed
	elif fw != 0 and bw == 0:
		velocity = Vector2(0, -1) * speed
	elif fw > bw:
		var str = (1 - bw / fw)
		velocity = Vector2(0, -1) * (speed * str)
	elif fw < bw:
		var str = (1 - fw / bw)
		velocity = Vector2(0, 1) * (speed * str)
		
	
	influence.fill(0)
	move_and_slide()
	pass 





func add_influence(inf_value : int, inf_type : Creature.Influence):
	influence[inf_type] += inf_value
	pass




func save() -> CreatureSave:

	var save = CreatureSave.new()

	return save


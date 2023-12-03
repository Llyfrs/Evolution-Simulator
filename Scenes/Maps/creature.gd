extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	velocity = Vector2(0,-1).rotated(rotation) * 300
	move_and_slide()



func rotate_left():
	rotate(-PI / 4)

func rotate_right():
	rotate(PI / 4)

func _on_desision_timeout():
	var desision = randi_range(0,1)
	
	if desision == 1:
		rotate_left()
	else :
		rotate_right()
	

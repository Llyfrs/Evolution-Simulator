extends Node
class_name DNA

var speed = {
	"Ground":0,
	"Sand":0,
	"Water":0
}


var size


# Called when the node enters the scene tree for the first time.
func _ready():
	
	speed["Ground"] = randf_range(0,1)
	speed["Sand"]   = randf_range(0,1)
	speed["Water"]  = randf_range(0,1)
	
	size = randi_range(10, 40)

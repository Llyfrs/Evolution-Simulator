extends Node

"""

This is experimental code. The idea is to limit the amount of entities in the game to prevent the game from freezing. It's not perfectly implemented atm and the current limits are way to high to have any effect. 

"""


enum {
	CREATURE,
	PLANT,
	SEED,
}

## Defines limits around how many of each entity there can be in the program, this should prevent the game from freezing because of to many entities._add_constant_central_force
## Set to 5000 everywhere to not effect the experiments but for uncontrolled runs it should be way lower.
var limits = [
	5000,
	5000,
	5000,
]




## Idea to watch the FPS and adjust the limits accordingly. Not implemented at this moment
var fps_history = []
## TODO: Implement dynamically changing limits 
func _process(_delta):
	var fps_current = Engine.get_frames_per_second()


	if fps_history.size() > 200:
		fps_history.pop_front()

	fps_history.append(fps_current)


	var fps_avg = fps_history.reduce(func(a, b) : return a + b, 0)/fps_history.size()

	#print("Avg FPS: " + str(fps_avg) )

	pass

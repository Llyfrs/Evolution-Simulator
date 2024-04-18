extends Node

enum {
	CREATURE,
	PLANT,
	SEED,
}


var limits = [
	5000,
	5000,
	5000,
]




var fps_history = []
## Implement dynamically changing limits 
func _process(_delta):
	var fps_current = Engine.get_frames_per_second()


	if fps_history.size() > 200:
		fps_history.pop_front()

	fps_history.append(fps_current)


	var fps_avg = fps_history.reduce(func(a, b) : return a + b, 0)/fps_history.size()

	#print("Avg FPS: " + str(fps_avg) )

	pass

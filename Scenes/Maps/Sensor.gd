class_name Sensor extends RayCast2D 


var conf : SensorSettings

signal detection(inf_value : int, inf_type : Creature.Influence)

func _ready():


	var distance = conf.range * Vector2(1, 0)

	target_position = distance.rotated(conf.angle)



	for masks in conf.processor.masks:
		set_collision_mask_value(masks, 1)


	enabled = true
	collide_with_areas = true
	collide_with_bodies = true

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
# I think we can ignore delta as the processing of influence is going to happen withing the same frame as it's defining
func _process(delta):


	## NOTE: Maybe add buffer? could be quite expensive to run and really we don't need to run it ever frame
	if !is_colliding():
		return

	if conf.processor == null or conf.receiver == null:
		print_debug("Missing processor or receiver")
		return
	
	var collider = get_collider()
	

	var data
	

	## TileMap should only be wall collision
	if collider is TileMap:
		data = Data.new()
		data.type = Data.DataType.WALL
		
	## Area2D is child of a plant so we need to get it's parent
	if collider is Area2D:
		
		var plant = collider.get_parent() as Plant
		data = PlantData.new()

		data.type = Data.DataType.PLANT
		data.energy = plant.energy
		data.health = plant.health
		data.color = plant.dna.color
		
	if collider is RigidBody2D:

		var sd = collider as Seed
		data = SeedData.new()

		data.energy = sd.energy

		if sd.dna != null:
			data.durability = sd.dna.seed_durability
		else:
			data.durability = 0;
	
	if data == null:
		return

	data.distance = get_collision_point().distance_to(global_position)

	if conf.processor.process(data):
		detection.emit(conf.influence * delta, conf.receiver)



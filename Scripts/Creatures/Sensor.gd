class_name Sensor extends RayCast2D 


var conf : SensorSettings

signal detection(inf_value : int, inf_type : Creature.Influence)

func _ready():


	var distance = conf.range * Vector2(1, 0)

	target_position = distance.rotated(conf.angle)


	for masks in conf.processor.masks:
		set_collision_mask_value(masks, 1)


	# If mask of the processor is empty we don't actually need to detect collision and this object will only server to collect other types of data, like the creature health and energy.
	enabled = !conf.processor.masks.is_empty()
	collide_with_areas = true
	collide_with_bodies = true

	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# Goal of this function every process frame is to collect all the data that is available.operator !=
	# Some like the creature internal data and calculating tiles that aren't detected by collision are only 
	# collected if the sensor is disabled. 


	if conf.processor == null or conf.receiver == null:
		push_error("Processor or Receiver are empty")
		return

	var all_data = []


	if !enabled:
		var dt = get_parent().get_parent().get_data() as SelfData
		all_data.append(dt)

		var tdt = TileTypeData.new()
		tdt.tiles = Globals.get_tile_type(global_to_map(global_position + target_position))
		all_data.append(tdt)


	## NOTE: Maybe add buffer? could be quite expensive to run and really we don't need to run it ever frame
	if is_colliding():

		var collider = get_collider()
		
		## TileMap should only be wall collision
		if collider is TileMap:
			var data = TileTypeData.new()
			data.tiles = [Globals.Tile.WALL]
			all_data.append(data)
			
		## Area2D is child of a plant so we need to get it's parent
		elif collider is Area2D:
			
			var plant = collider.get_parent() as Plant
			var data = PlantData.new()

			data.energy = plant.energy
			data.health = plant.health
			data.color = plant.dna.color

			all_data.append(data)

		elif collider is RigidBody2D:

			var sd = collider as Seed
			var data = SeedData.new()

			data.energy = sd.energy

			if sd.dna != null:
				data.durability = sd.dna.seed_durability
			else:
				data.durability = 0;
			
			all_data.append(data)
			
		elif collider is CollisionObject2D:
			var creature = collider as Creature
			var data = CreatureData.new()
			
			data.energy = creature.energy
			data.health = creature.health

			all_data.append(data)

	var distance = get_collision_point().distance_to(global_position)
	for data in all_data:
		data.distance = distance

		if conf.processor.process(data):
			detection.emit( conf.influence * delta, conf.receiver)
			return





func global_to_map(pos):
	return Globals.mainMap.local_to_map(Globals.mainMap.to_local(pos))

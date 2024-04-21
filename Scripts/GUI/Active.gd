extends Node



func _process(delta):
	
	if EnergyManager.plants.size() < Globals.min_plants:
		
		var tile = EnergyManager.tiles.keys().pick_random()
		tile = Globals.mainMap.to_global(Globals.mainMap.map_to_local(tile))

		tile += Vector2(randi_range(-32, 32), randi_range(-32,32))

		root_seed(PlantDNA.new(), tile)
		
		pass
	
	
	if EnergyManager.creatures.size() < Globals.min_creatures:
		
		var tile = EnergyManager.tiles.keys().pick_random()
		tile = Globals.mainMap.to_global(Globals.mainMap.map_to_local(tile))
		spawn_creature(CreatureDNA.new(), tile)
		
		pass


## Extracted from seed to allow for seed to exists in sub-thread
func root_seed(dna : PlantDNA, global_pos):
		var plant = Globals.plant_scene.instantiate()
		
		plant.set_dna(dna)
		plant.global_position = global_pos
		
		add_child(plant)


func spawn_creature(dna: CreatureDNA, global_pos):
	
	var creature = Globals.creature_scene.instantiate() as Creature
	
	creature.dna = dna
	creature.global_position = global_pos
	
	add_child(creature)
	
	pass

func _input(event):
	
	if Globals.cursor_obscured:
		return
	
	if event.is_action_pressed("ui_left_mouse_button"):
		var position = Globals.mainMap.get_global_mouse_position()
		if Globals.cursor == Globals.CursorMode.CREATURE:
			for i in range(1):
				spawn_creature(CreatureDNA.new(), position)
				
		elif Globals.cursor == Globals.CursorMode.PLANT:
			root_seed(PlantDNA.new(), position)

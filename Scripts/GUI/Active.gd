extends Node

"""

Is attached to the Active node in main scene. It's job is to hold functions for spawning creatures and plants, 
as well as to manage the spawning of new creatures and plants when the number of creatures or plants falls below a certain threshold.


"""

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


## Extracted from seed to allow for seed to exists in sub-thread (Adding to the scene tree can only be done in the main thread)
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


## Handles input for spawning creatures and plants. Either it generates new DNA or uses one form the Globals.copy variable
func _input(event):
	
	if Globals.cursor_obscured:
		return
	
	if event.is_action_pressed("ui_left_mouse_button"):
		var position = Globals.mainMap.get_global_mouse_position()
		if Globals.cursor == Globals.CursorMode.CREATURE:
			
			var dna = CreatureDNA.new()
			if Globals.copy is CreatureDNA:
				dna = Globals.copy
			
			spawn_creature(dna, position)
				
		elif Globals.cursor == Globals.CursorMode.PLANT:
			
			var dna = PlantDNA.new()
			if Globals.copy is PlantDNA:
				dna = Globals.copy
			
			root_seed(dna, position)

extends Node


func root_seed(dna : PlantDNA, global_pos):
		var plant = Globals.plant_scene.instantiate()
		
		plant.set_dna(dna)
		plant.global_position = global_pos
		
		
		add_child(plant)

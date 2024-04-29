extends Control

var creature_texture = preload("res://Textures/Creature/creature.png")
var plant_texture = preload("res://Textures/Plant/plant_small_AI.png")

var creature_count = 0
var plant_count = 0

func _ready():
	$SavedPlants/Random/Delete.visible = false
	$SavedCreatures/Random/Delete.visible = false
	
	$SavedCreatures/Random.pressed.connect(func(): load_creature(null))
	$SavedPlants/Random.pressed.connect(func(): load_plant(null))
	


## This is far from the most effective solution but is definetly the cleanes. 
## This saves me the work and mess of creating signals and connecting them with the global class
func _process(delta):
	
	if $SavedCreatures.visible:
		if creature_count != Globals.saved_creatures.size():
			creature_count = Globals.saved_creatures.size()
			_load_saved($SavedCreatures, Globals.saved_creatures, load_creature, delete_creature)
			
	elif $SavedPlants.visible:
		if plant_count != Globals.saved_plants.size():
			plant_count = Globals.saved_plants.size()
			_load_saved($SavedPlants, Globals.saved_plants , load_plant, delete_plant)
				
		

func _on_select_pressed():
	Globals.cursor = Globals.CursorMode.SELECT
	pass # Replace with function body.


func _on_paint_pressed():
	_toggle_menu($PaintOptions)
	
	pass # Replace with function body.

func load_plant(dna : PlantDNA):
	Globals.cursor = Globals.CursorMode.PLANT
	Globals.copy = dna
	pass

func delete_plant(plant):
	Globals.saved_plants.erase(plant)
	pass


func _on_plant_pressed():
	_toggle_menu($SavedPlants)
	_load_saved($SavedPlants, Globals.saved_plants , load_plant, delete_plant)
	pass # Replace with function body.


func load_creature(dna : CreatureDNA):
	Globals.cursor = Globals.CursorMode.CREATURE
	Globals.copy = dna
	pass

func delete_creature(creature):
	Globals.saved_creatures.erase(creature)
	pass

func _on_creature_pressed():
	_toggle_menu($SavedCreatures)
	_load_saved($SavedCreatures, Globals.saved_creatures, load_creature, delete_creature)
	
	pass # Replace with function body.


func _toggle_menu(menu):
	if menu.visible:
		_close_all()
	else:
		_close_all()
		menu.visible = true

func _load_saved(node, organisms, loadf : Callable, delete : Callable):
	
	for child in node.get_children():
		if not child.name in ["Random"]:
			child.queue_free()
	
	for creature in organisms:
		var box = node.get_node("Random").duplicate(true)
		
		if creature.dna is PlantDNA:
			box.get_node("Texture").texture = plant_texture
		else:
			box.get_node("Texture").texture = creature_texture
		
		box.get_node("Texture").modulate = creature.dna.color
		box.get_node("Name").text = creature.name
		box.get_node("Delete").visible = true
		
		box.pressed.connect(func(): loadf.call(creature.dna))
		box.get_node("Delete").pressed.connect(func(): delete.call(creature))
 		
		node.add_child(box)

func _on_grass_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.GRASS
	_close_all()
	pass # Replace with function body.
	
func _on_stone_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.STONE
	_close_all()
	pass # Replace with function body.

func _on_water_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.WATER
	_close_all()
	pass # Replace with function body.

func _on_sand_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.SAND
	_close_all()
	pass # Replace with function body.

func _on_wall_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.WALL
	_close_all()
	pass # Replace with function body.	


func _close_all():
	$SavedCreatures.visible = false
	$PaintOptions.visible = false
	$SavedPlants.visible = false
	

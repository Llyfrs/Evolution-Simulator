extends Node2D

enum {
	WATER_TILE,
	GRASS_TILE,
	STONE_TILE,
	SAND_TILE,
	WALL_TILE
}

var tiles = [
	Globals.GRASS_TILE,
	Globals.STONE_TILE,
	Globals.WATER_TILE,
	Globals.SAND_TILE,
	Globals.WALL_TILE
]

var is_drawing : bool = false
var is_deleting: bool = false
var is_obsucred : bool = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var temp_timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var position = Globals.mainMap.local_to_map(Globals.mainMap.get_local_mouse_position())
	

	if is_drawing and not is_obsucred:
		draw_tile(position, Globals.paint_mode)
	elif is_deleting and not is_obsucred:
		delete_tile(position)
	
	temp_timer += delta
	if temp_timer >= 1:
		draw_energy()
		temp_timer = 0
	

	
	pass


func _on_grass_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.GRASS
	pass # Replace with function body.
	

func _on_stone_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.STONE
	pass # Replace with function body.


func _on_water_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.WATER
	pass # Replace with function body.


func _on_sand_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.SAND
	pass # Replace with function body.
	
func _on_wall_pressed():
	Globals.cursor = Globals.CursorMode.PAINT
	Globals.paint_mode = Globals.PaintMode.WALL
	pass # Replace with function body.	

func obscure():
	is_obsucred = true
	
func un_obscure():
	is_obsucred = false

func draw_tile(position: Vector2, type : int):
	var map = $TileMap as TileMap
	map.set_cell(0, position, 0, tiles[type])
	
	
	if not EnergyManager.tiles.has(position):
		EnergyManager.set_energy(position, 100)
	
	var surounding = map.get_surrounding_cells(position)
	
	if Globals.paint_mode == Globals.PaintMode.WALL:
		EnergyManager.tiles.erase(position)
		return
	
	for cell in surounding:
		if map.get_cell_tile_data(0, cell) == null:
			map.set_cell(0, cell, 0, Globals.WALL_TILE)
	
	
func delete_tile(position : Vector2):
	var map = $TileMap as TileMap
	map.erase_cell(0, position)

	EnergyManager.tiles.erase(position)
	
	var surounding = map.get_surrounding_cells(position)
	
	for cell in surounding:
		var cords = map.get_cell_atlas_coords(0, cell)
		if cords != Globals.WALL_TILE and cords != Vector2i(-1, -1):
			map.set_cell(0, cell, 0, Globals.WALL_TILE)


func draw_energy():
	
	for child in $Energy.get_children():
		child.queue_free()
		
	for tile in EnergyManager.tiles:
		var position = Globals.mainMap.to_global(Globals.mainMap.map_to_local(tile))
		var lable = Label.new()
		lable.text = str(round(EnergyManager.tiles[tile]))
		lable.global_position = position 
		lable.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		$Energy.add_child(lable)
	

func _input(event):
	
	if Globals.cursor != Globals.CursorMode.PAINT:
		return
	
	if event.is_action_pressed("ui_left_mouse_button"):
		is_drawing = true
		
	if event.is_action_released("ui_left_mouse_button"):
		is_drawing = false
	
	if event.is_action_pressed("ui_right_mouse_button"):
		is_deleting = true
		
	if event.is_action_released("ui_right_mouse_button"):
		is_deleting = false
	
	
	
	pass




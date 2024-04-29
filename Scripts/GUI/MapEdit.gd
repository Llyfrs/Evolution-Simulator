extends Node2D

"""

This script is responsible for drawing and deleting tiles on the map. It mostly uses the set_cell function of the TileMap. 
It makes sure no tile is open to a empty space by surrounding it with walls. It also makes sure that the energy is set for each tile according to the tile_energy variable in the Globals script.

"""


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

var show_energy : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var temp_timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var position = Globals.mainMap.local_to_map(Globals.mainMap.get_local_mouse_position())
	
	if is_drawing and not Globals.cursor_obscured :
		draw_tile(position, Globals.paint_mode)
	elif is_deleting and not Globals.cursor_obscured :
		delete_tile(position)
	
	
	if !show_energy:
		return
	
	temp_timer += delta
	if temp_timer >= 1:
		draw_energy()
		temp_timer = 0
	
	pass


## Ton of GUI elements use this functions to set the obscure state of the cursor
## It could be done in a way where each GUI element has it's own script to do this and the function could be just global but this works and is easy to set up using the godot editor
func obscure():
	Globals.cursor_obscured = true

func un_obscure():
	Globals.cursor_obscured = false

func draw_tile(position: Vector2, type : int):
	
	var map = $TileMap as TileMap
	map.set_cell(0, position, 0, tiles[type])
	
	
	if not EnergyManager.tiles.has(position):
		EnergyManager.set_energy(position, Globals.tile_energy)
	
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
			EnergyManager.tiles.erase(Vector2(cell))


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


func _on_check_box_toggled(toggled_on):
	
	print(toggled_on)
	
	show_energy = toggled_on
	$Energy.visible = toggled_on
	
	pass # Replace with function body.


func _on_spin_box_value_changed(value):
	
	Globals.tile_energy = value
	
	pass # Replace with function body.

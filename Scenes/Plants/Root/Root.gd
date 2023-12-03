extends Node2D
class_name Root
@export var rootMap : TileMap
@export var run : bool


var dna : PlantDNA

## If plant grown since last tilemap presence was calculated. This infromation
## is used to determine if cached data should be used.
var _grown : bool = true
var _presence_cache : Dictionary 

var index_map = Dictionary()
var active_roots = []
var inactive_roots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	var start = rootMap.local_to_map(rootMap.to_local(global_position))
#
#	set_cell(start, true)
#	index_map[start] = 0
	
	if run:
		dna = PlantDNA.new()
		set_rootMap(rootMap)
		$Timer.start()


	pass	

func set_rootMap(map : TileMap):
	rootMap = map
	
	var start = rootMap.local_to_map(rootMap.to_local(global_position))
	
	if rootMap.get_cell_tile_data(0, start) != null:
		return;
	
	set_cell(start, true)
	index_map[start] = 0
	

# Grows the root by one step
# Returns true if the growth was succesfull, 
# Returns false if it wasn't and there aren't any more active roots
func grow(plantDNA : PlantDNA) -> int:
	
	_grown = true

	active_roots.sort_custom(compare)
	
	if active_roots.size() == 0:
		return -1
	
	var index = floor((active_roots.size()-1) * plantDNA.root_distance_from_source)

	var source = active_roots[index]
	
	var pattern = plantDNA.root_pattern[index_map[source]].pick_random()
	
	if pattern == null:
		set_cell(source, false)
		return true
	
	var cells_grown = 0
	var surround = rootMap.get_surrounding_cells(source)
	
	for i in range(4):
		if rootMap.get_cell_source_id(0,surround[i]) == -1 and pattern[i] != -1:
			set_cell(surround[i], true)
			index_map[surround[i]] = pattern[i]
			cells_grown += 1
	
	set_cell(source, false)
	
	return cells_grown

func get_tilemap_presence(tilemap : TileMap, p_dna : PlantDNA):
	
	if !_grown:
		return _presence_cache
	
	var roots = inactive_roots.duplicate()
	roots.append_array(active_roots)
	
	var presence = Dictionary()
	
	for root in roots:
		var global = rootMap.to_global(rootMap.map_to_local(root))
		var cords = tilemap.local_to_map(tilemap.to_local(global))
		
		if presence.has(cords) : 
			presence[cords] += p_dna.root_effectivnes
		else:
			presence[cords] = p_dna.root_effectivnes
	
	_grown = false
	_presence_cache = presence
	return presence
	


func set_cell(cords : Vector2i, active : bool):
	rootMap.set_cell(0, cords,0,Vector2(0,0),active)
	
	if active:
		active_roots.append(cords)
	else:
		active_roots.erase(cords)
		inactive_roots.append(cords)
	pass

func highlight_owned_roots(highlight : bool):
	
	var state = 2 if highlight else 0
	
	for root in inactive_roots:
		rootMap.set_cell(0, root, 0, Vector2(0, 0), state)
	
	state = 2 if highlight else 1
	
	for root in active_roots:
		rootMap.set_cell(0, root, 0, Vector2(0, 0), state)
	
	pass



func _on_timer_timeout():
	grow(dna)

func compare(a : Vector2i, b: Vector2i):
	return a.length_squared() < b.length_squared()


func _on_tree_exiting():
	for root in active_roots:
		rootMap.erase_cell(0, root)
		
	for root in inactive_roots:
		rootMap.erase_cell(0, root)
	
	pass # Replace with function body.

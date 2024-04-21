extends Node2D
class_name Root

"""

Ton of catching happening in this class. The reason for is that transferring between global and local positions and main and root map is quite expensive but also
not needed to be done again unless the root grown, meaning if the root stops growing it's impact on performance will be significantly reduced.

"""


@export var run : bool

## Only used for testing, does otherwise not hold DNA on it's own
var dna : PlantDNA

## If plant grown since last tilemap presence was calculated. This infromation
## is used to determine if cached data should be used.
var _grown : bool = true
var _presence_cache : Dictionary 
var _cost_cache : float
var _source_cache 

var _root_map_position : Vector2

var index_map = Dictionary()
var active_roots = []
var inactive_roots = []



# Called when the node enters the scene tree for the first time.
func _ready():
	
	var start = Globals.rootMap.local_to_map(Globals.rootMap.to_local(global_position))


	if Globals.rootMap.get_cell_tile_data(0, start) == null:
		set_cell(start, true)
		index_map[start] = 0


	_root_map_position = Globals.rootMap.to_local(global_position)

	if run:
		dna = PlantDNA.new()
		#set_rootMap(rootMap)
		$Timer.start()


	pass	

# func set_rootMap(map : TileMap):
# 	var start = GlobalMaps.rootMap.local_to_map(GlobalMaps.rootMap.to_local(global_position))
	
# 	if GlobalMaps.rootMap.get_cell_tile_data(0, start) != null:
# 		return;
	
# 	set_cell(start, true)
# 	index_map[start] = 0
# 	pass
	

## Grows the root by one step
## Returns true if the growth was successful, 
## Returns false if it wasn't and there aren't any more active roots
func grow(plantDNA : PlantDNA) -> float:

	_grown = true


	if active_roots.size() == 0:
		return -1

	var source = _get_next_source(plantDNA)
	
	
	if plantDNA.root_pattern.is_empty():
		set_cell(source, false)
		return true
		
	
	var pattern = null if plantDNA.root_pattern[index_map[source]].is_empty() else plantDNA.root_pattern[index_map[source]].pick_random()
	
	if pattern == null:
		set_cell(source, false)
		return true
	
	var cells_grown = 0
	var surround = Globals.rootMap.get_surrounding_cells(source)
	
	for i in range(4):
		if Globals.rootMap.get_cell_source_id(0,surround[i]) == -1 and pattern[i] != -1 and _is_valid_location(surround[i]):
			set_cell(surround[i], true)
			index_map[surround[i]] = pattern[i]
			cells_grown += 1
	

	set_cell(source, false)
	
	## The cost is equal to the amount of roots grown, so growing less roots means less energy spend
	return grow_cost(plantDNA) * (4.0/cells_grown)


## Returns the cost of growing all 4 roots
func grow_cost(plantDNA : PlantDNA):

	if !_grown:
		return _cost_cache

	if active_roots.size() == 0:
		return -1


	var source = _get_next_source(plantDNA)

	var distance = (Globals.rootMap.map_to_local(source) - _root_map_position).length()  

	var cost = ( ( pow(distance, 1.6) / 300 ) + 5 ) * 4

	_cost_cache = cost

	return cost


func _get_next_source(plantDNA : PlantDNA):


	if !_grown:
		return _source_cache

	active_roots.sort_custom(compare)
	var index = floor((active_roots.size()-1) * min(plantDNA.root_distance_from_source, 1))
	_source_cache = active_roots[index]
	return _source_cache



## Returns list of MainMap tiles and how many roots are present on them.  
## Caches the results to potencially improve performance if called on not grown root
func get_tilemap_presence(tilemap : TileMap, p_dna : PlantDNA):
	
	if !_grown:
		return _presence_cache
	
	var roots = inactive_roots.duplicate()
	roots.append_array(active_roots)
	
	var presence = Dictionary()
	
	for root in roots:
		var global = Globals.rootMap.to_global(Globals.rootMap.map_to_local(root))
		var cords = tilemap.local_to_map(tilemap.to_local(global))
		
		if presence.has(cords) : 
			presence[cords] += p_dna.root_effectivnes
		else:
			presence[cords] = p_dna.root_effectivnes
	
	_grown = false
	_presence_cache = presence
	return presence
	

func _is_valid_location(pos : Vector2i):
	var global = Globals.rootMap.to_global(Globals.rootMap.map_to_local(pos))
	var map = Globals.mainMap.local_to_map(Globals.mainMap.to_local(global))

	return !Globals.get_tile_type(map).is_empty()





func set_cell(cords : Vector2i, active : bool):
	Globals.rootMap.set_cell(0, cords,0,Vector2(0,0),active)
	
	if active:
		active_roots.append(cords)
	else:
		active_roots.erase(cords)
		inactive_roots.append(cords)
	pass

func highlight_owned_roots(highlight : bool):
	
	var state = 2 if highlight else 0
	
	for root in inactive_roots:
		Globals.rootMap.set_cell(0, root, 0, Vector2(0, 0), state)
	
	state = 2 if highlight else 1
	
	for root in active_roots:
		Globals.rootMap.set_cell(0, root, 0, Vector2(0, 0), state)
	
	pass



func _on_timer_timeout():
	grow(dna)

func compare(a : Vector2i, b: Vector2i):
	var a_local = Globals.rootMap.map_to_local(a) - _root_map_position
	var b_local = Globals.rootMap.map_to_local(b) - _root_map_position

	return a_local.length_squared() < b_local.length_squared()


func _on_tree_exiting():
	for root in active_roots:
		Globals.rootMap.erase_cell(0, root)
	for root in inactive_roots:
		Globals.rootMap.erase_cell(0, root)
	
	pass # Replace with function body.


func save() -> RootSave:
	var sv = RootSave.new()

	sv.index_map = index_map
	sv.active_roots = active_roots
	sv.inactive_roots = inactive_roots

	return sv


func load(sv : RootSave): 
	
	index_map = sv.index_map
	active_roots = sv.active_roots
	inactive_roots = sv.inactive_roots

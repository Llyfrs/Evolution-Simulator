extends Node2D
#lass_name Root
@export var rootMap : TileMap

var index_map = Dictionary()
var dna : PlantDNA = PlantDNA.new()

## If plant grown since last tilemap presence was calculated. This infromation
## is used to determine if cached data should be used.
var _grown : bool = true
var _presence_cache : Dictionary 

# Called when the node enters the scene tree for the first time.
func _ready():
	set_cell(Vector2(0,0), true)
	index_map[Vector2i(0,0)] = 0
	

#	for i in range(dna.root_pattern.size()):
#		print("#"+str(i)+": " + str(dna.root_pattern[i]))

	var dna = PlantDNA.new()
	
	$Timer.start()

	

# Grows the root by one step
# Returns true if the growth was succesfull, 
# Returns false if it wasn't and there aren't any more active roots
func grow(plantDNA : PlantDNA) -> int:
	
	_grown = true
	var active_roots = $RootMap.get_used_cells_by_id(0,0,Vector2i(0,0),1) as Array
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
	var surround = $RootMap.get_surrounding_cells(source)
	
	for i in range(4):
		if $RootMap.get_cell_source_id(0,surround[i]) == -1 and pattern[i] != -1:
			set_cell(surround[i], true)
			index_map[surround[i]] = pattern[i]
			cells_grown += 1
	
	set_cell(source, false)
	
	return cells_grown

func get_tilemap_presence(tilemap : TileMap, dna : PlantDNA):
	
	if !_grown:
		return _presence_cache
		pass 
	
	
	var roots = $RootMap.get_used_cells(0)
	var presence = Dictionary()
	
	for root in roots:
		var global = $RootMap.to_global($RootMap.map_to_local(root))
		var cords = tilemap.local_to_map(tilemap.to_local(global))
		
		if presence.has(cords) : 
			presence[cords] += dna.root_effectivnes
		else:
			presence[cords] = dna.root_effectivnes
	
	_grown = false
	_presence_cache = presence
	return presence
	


func set_cell(cords : Vector2i, active : bool):
	$RootMap.set_cell(0, cords,0,Vector2(0,0),active)
	pass

func _on_timer_timeout():
	grow(dna)

func compare(a : Vector2i, b: Vector2i):
	return a.length_squared() < b.length_squared()

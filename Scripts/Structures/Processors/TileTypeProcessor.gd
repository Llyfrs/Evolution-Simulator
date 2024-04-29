class_name TileTypeProcessor extends Processor


@export var tileType : Globals.Tile


func _init():

	tileType = Globals.Tile.values().pick_random()

	if tileType == Globals.Tile.WALL:
		masks = [Globals.Mask.TILE_MAP]


func process(data : Data):
	
	if data is TileTypeData:
		return tileType in data.tiles
	
	return false


## Mutate handled in super, there is nothing to change here.



func _to_string():
	return "TileTypeProcessor: " + Globals.Tile.keys()[tileType]

func _to_dict():
	return {
		"type": "TileTypeProcessor",
		"tileType": Globals.Tile.keys()[tileType]
	}


func get_color():
	
	if tileType == Globals.Tile.WALL:
		return Color.BLACK

	if tileType == Globals.Tile.WATER:
		return Color.BLUE
	
	if tileType == Globals.Tile.GRASS:
		return Color.GREEN

	if tileType == Globals.Tile.SAND:
		return Color.YELLOW

	if tileType == Globals.Tile.STONE:
		return Color.DARK_GRAY


	return Color.ANTIQUE_WHITE


func get_processor_name():
	return "Tile Type Sensor"

func get_description():
	var text = ""
	text += "Detecting: " + Globals.Tile.keys()[tileType] + "\n"
	return text



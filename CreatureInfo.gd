extends Control

@onready var active = get_parent().get_parent().get_node("Active")

@onready var energy_bar = $PanelContainer2/PanelContainer/GridContainer/EnergyCenter/EnergyBar
@onready var health_bar = $PanelContainer2/PanelContainer/GridContainer/HealthCenter/HealthBar

@onready var energy_count = $PanelContainer2/PanelContainer/GridContainer/EnergyCenter/EnergyCount
@onready var health_count = $PanelContainer2/PanelContainer/GridContainer/HealthCenter/HealthCount

@onready var DNAGrid = $PanelContainer2/PanelContainer/DNAGrid

@onready var water = $PanelContainer2/PanelContainer/Proficiency/WatterT
@onready var rock = $PanelContainer2/PanelContainer/Proficiency/RockT
@onready var sand = $PanelContainer2/PanelContainer/Proficiency/SandT
@onready var grass = $PanelContainer2/PanelContainer/Proficiency/GrassT

@onready var tax = $PanelContainer2/PanelContainer/TaxCost

var influence : Dictionary

var selected
# Called when the node enters the scene tree for the first time.
func _ready():
	
	influence[Creature.Influence.MOVE_BACKWARDS] = $PanelContainer2/PanelContainer/Influence/InfluenceMoveB
	influence[Creature.Influence.MOVE_FORWARD] = $PanelContainer2/PanelContainer/Influence/InfluenceMoveF
	influence[Creature.Influence.ROTATE_LEFT] = $PanelContainer2/PanelContainer/Influence/InfluenceRotateL
	influence[Creature.Influence.ROTATE_RIGHT] = $PanelContainer2/PanelContainer/Influence/InfluenceRotateR
	influence[Creature.Influence.PAUSE_ATTACKING] = $PanelContainer2/PanelContainer/Influence/InfluenceStopA
	influence[Creature.Influence.PAUSE_REPRODUCTION] = $PanelContainer2/PanelContainer/Influence/InfluenceStopR

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Also hides when selected is null
	if selected == null or not selected is Creature:
		self.visible = false
		return
		
	
	energy_bar.value = selected.energy
	energy_bar.tooltip_text = str(selected.energy)
	health_bar.value = selected.health
	health_bar.tooltip_text = str(selected.health)
	
	energy_count.text = str(round(selected.energy)) + " / " + str(selected.dna.energy)
	health_count.text = str(round(selected.health)) + " / " + str(selected.dna.health)
	
	
	var max = max(selected.influence.max(), 1)
	for value in Creature.Influence.values():
		influence[value].value = selected.influence[value]
		influence[value].max_value = max
	
	if selected.is_immortal:
		$PanelContainer2/PanelContainer/Imortal.text = "Is Imortal"
	else: 
		$PanelContainer2/PanelContainer/Imortal.text = "Is Mortal"
	pass


func _input(event):
	if event.is_action_pressed("ui_left_mouse_button"):
		if not Globals.selected.is_empty() and Globals.selected[0] is Creature:
			self.visible = true
			change_selected(Globals.selected[0])
		else:
			self.visible = false


func change_selected(new_selected):
	selected = new_selected as Creature
	
	energy_bar.max_value = selected.dna.energy
	health_bar.max_value = selected.dna.health
	
	for child in DNAGrid.get_children():
		child.queue_free()
	

	var offspring = Label.new()
	offspring.text = "Offsprings: " + str(selected.dna.offsprings) + " (" + str(selected.dna.offspring_energy) + "e)" 
	DNAGrid.add_child(offspring)


	var bite_strength = Label.new()
	bite_strength.text = "Bite: " + str(selected.dna.bite_strength)
	DNAGrid.add_child(bite_strength)


	var speed = Label.new()
	speed.text = "Speed: " + str(selected.dna.speed) + " (R: " + str(selected.dna.rotation_speed) + ")"
	DNAGrid.add_child(speed)


	for value in Creature.Influence.values():
		influence[value].tooltip_text = "Decay: " + str(selected.dna.influence_decay[value]	)


	water.text = str(snapped(selected.dna.tile_efficiency[Globals.Tile.WATER], 0.01)) + "x"
	grass.text = str(snapped(selected.dna.tile_efficiency[Globals.Tile.GRASS], 0.01)) + "x"
	rock.text  = str(snapped(selected.dna.tile_efficiency[Globals.Tile.STONE], 0.01)) + "x"
	sand.text  = str(snapped(selected.dna.tile_efficiency[Globals.Tile.SAND], 0.01)) + "x"
	
	tax.text = "Cost: " + str(selected.dna.proficiency_tax())
	
	pass

extends Control

@onready var active = get_parent().get_parent().get_node("Active")

@onready var energy_bar = $PanelContainer2/PanelContainer/GridContainer/EnergyCenter/EnergyBar
@onready var health_bar = $PanelContainer2/PanelContainer/GridContainer/HealthCenter/HealthBar

@onready var energy_count = $PanelContainer2/PanelContainer/GridContainer/EnergyCenter/EnergyCount
@onready var health_count = $PanelContainer2/PanelContainer/GridContainer/HealthCenter/HealthCount

@onready var DNAGrid = $PanelContainer2/PanelContainer/DNAGrid

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
	selected = new_selected
	
	energy_bar.max_value = selected.dna.energy
	health_bar.max_value = selected.dna.health
	
	for child in DNAGrid.get_children():
		child.queue_free()
	
	for property in selected.dna.get_property_list():
		if property["type"] == 2 or property["type"] == 3:
			var label = Label.new()
			label.text = property["name"] + ": " + str(selected.dna.get(property["name"]))
			DNAGrid.add_child(label)
	
	var label = Label.new()
	label.text = "Prof Tax: " + str(selected.dna.proficiency_tax())
	DNAGrid.add_child(label)
	
	pass

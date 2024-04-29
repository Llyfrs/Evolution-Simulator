extends Control

"""

Puts data from a creature to a GUI panel.

"""

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

@onready var generation = $PanelContainer2/PanelContainer/Generation

@onready var sensors = $Sensors/ColorRect
@onready var creature_texture = $Sensors/ColorRect/CreatureTexture
@onready var arrow_template = $Sensors/ColorRect/ArrowTemplate

@onready var internal_sensors = $Sensors/Panel/InternalSensors
@onready var circle_template = $Sensors/Panel/InternalSensors/TemplateCircle

@onready var sensors_info = $SensorInfo/VBoxContainer
@onready var processor_name = $SensorInfo/VBoxContainer/Name
@onready var processor_description = $SensorInfo/VBoxContainer/Description

@onready var pop_up = $Save

var influence : Dictionary

var selected


var obscured : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	influence[Creature.Influence.MOVE_BACKWARDS] = $PanelContainer2/PanelContainer/Influence/InfluenceMoveB
	influence[Creature.Influence.MOVE_FORWARD] = $PanelContainer2/PanelContainer/Influence/InfluenceMoveF
	influence[Creature.Influence.ROTATE_LEFT] = $PanelContainer2/PanelContainer/Influence/InfluenceRotateL
	influence[Creature.Influence.ROTATE_RIGHT] = $PanelContainer2/PanelContainer/Influence/InfluenceRotateR
	influence[Creature.Influence.PAUSE_ATTACKING] = $PanelContainer2/PanelContainer/Influence/InfluenceStopA
	influence[Creature.Influence.PAUSE_REPRODUCTION] = $PanelContainer2/PanelContainer/Influence/InfluenceStopR
	
	arrow_template.visible = false
	circle_template.visible = false
	
	
	pop_up.result.connect(_handle_result)
	add_child(pop_up)

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
		elif Globals.cursor_obscured:
			return
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
	offspring.tooltip_text = "How many offsprings this creature has and how much energy it gives each"
	DNAGrid.add_child(offspring)


	var bite_strength = Label.new()
	bite_strength.text = "Bite: " + str(selected.dna.bite_strength)
	offspring.tooltip_text = "Bite strength"
	DNAGrid.add_child(bite_strength)


	var speed = Label.new()
	speed.text = "Speed: " + str(selected.dna.speed) + " (R: " + str(selected.dna.rotation_speed) + ")"
	speed.tooltip_text = "Movement speed and rotation speed"
	DNAGrid.add_child(speed)


	for value in Creature.Influence.values():
		influence[value].tooltip_text = "Decay: " + str(selected.dna.influence_decay[value]	)


	water.text = str(snapped(selected.dna.tile_efficiency[Globals.Tile.WATER], 0.01)) + "x"
	grass.text = str(snapped(selected.dna.tile_efficiency[Globals.Tile.GRASS], 0.01)) + "x"
	rock.text  = str(snapped(selected.dna.tile_efficiency[Globals.Tile.STONE], 0.01)) + "x"
	sand.text  = str(snapped(selected.dna.tile_efficiency[Globals.Tile.SAND], 0.01)) + "x"
	
	tax.text = "Cost: " + str(selected.dna.proficiency_tax())
	
	generation.text = "Generation: " + str(selected.dna.generation)
	
	creature_texture.modulate = selected.dna.color
	
	for child in sensors.get_children():
		if not child.name in ["CreatureTexture", "ArrowTemplate"]:
			child.queue_free() 
			
	for child in internal_sensors.get_children():
		if not child.name in ["TemplateCircle"]:
			child.queue_free()
	
	for sensor : SensorSettings in selected.dna.sensors:

		if sensor.processor.is_internal():
			
			var circle = circle_template.duplicate()
			circle.visible = true
			circle.modulate = sensor.processor.get_color()
			circle.mouse_entered.connect(func() : display_sensor_info(sensor))
			internal_sensors.add_child(circle)
		else: 
			var arrow = arrow_template.duplicate() 
			arrow.visible = true
			arrow.rotation = sensor.angle
			arrow.modulate = sensor.processor.get_color()
			arrow.mouse_entered.connect(func() : display_sensor_info(sensor))
			sensors.add_child(arrow)

	
	pass


func display_sensor_info(sensor : SensorSettings):
	processor_name.text = sensor.processor.get_processor_name()
	
	processor_description.text = ""
	processor_description.text += "Distance: " + str(sensor.range) + "\n"
	processor_description.text += "Target: " + Creature.Influence.keys()[sensor.receiver] + "\n"
	processor_description.text += "Influence: " + str(sensor.influence) + "\n"
	processor_description.text += sensor.processor.get_description()
	
	pass


func _on_copy_pressed():
	Globals.cursor = Globals.CursorMode.CREATURE
	Globals.copy = selected.dna.duplicate(true)


func _handle_result(name : String):
	
	if name == "":
		return
	
	var new = NamedCreature.new()
	new.name = name
	new.dna = selected.dna.duplicate(true)
	Globals.saved_creatures.append(new)
	pass

func _on_save_pressed():
	get_tree().paused = true	
	pop_up.visible = true
	
	pass # Replace with function body.


func _on_mouse_entered():
	Globals.cursor_obscured = true
	pass # Replace with function body.


func _on_mouse_exited():
	Globals.cursor_obscured = false
	pass # Replace with function body.


extends Control

"""

Puts data from a plant to a GUI panel.

"""


@onready var energy_bar = $PanelContainer2/PanelContainer/GridContainer/EnergyCenter/EnergyBar
@onready var health_bar = $PanelContainer2/PanelContainer/GridContainer/HealthCenter/HealthBar

@onready var energy_count = $PanelContainer2/PanelContainer/GridContainer/EnergyCenter/EnergyCount
@onready var health_count = $PanelContainer2/PanelContainer/GridContainer/HealthCenter/HealthCount

@onready var DNAGrid = $PanelContainer2/PanelContainer/DNAGrid
@onready var generation = $PanelContainer2/PanelContainer/Generation

@onready var pop_up = $Save

var selected
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pop_up.result.connect(_handle_result)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if selected == null or not selected is Plant:
		self.visible = false
		return
	
	
	energy_bar.value = selected.energy
	energy_bar.tooltip_text = str(selected.energy)
	health_bar.value = selected.health
	health_bar.tooltip_text = str(selected.health)
	
	energy_count.text = str(round(selected.energy)) + " / " + str(selected.dna.energy)
	health_count.text = str(round(selected.health)) + " / " + str(selected.dna.health)
	
	pass


func _input(event):
	if event.is_action_pressed("ui_left_mouse_button"):
		if not Globals.selected.is_empty() and Globals.selected[0] is Plant:
			self.visible = true
			change_selected(Globals.selected[0])
		elif Globals.cursor_obscured:
			return
		else:
			self.visible = false
			


func change_selected(plant : Plant):
	selected = plant
	
	energy_bar.max_value = selected.dna.energy
	health_bar.max_value = selected.dna.health
	
	for child in DNAGrid.get_children():
		child.queue_free()

	var grow_speed = Label.new()
	grow_speed.text = "Grow Speed: " + str(snapped(selected.dna.plant_grow_speed,2))
	DNAGrid.add_child(grow_speed)

	var seeds = Label.new()
	seeds.text = "Seeds: " + str(selected.dna.seed_quantity) + " (" + str(selected.dna.seed_nutrition) + "e)"
	DNAGrid.add_child(seeds)

	var seed_durab = Label.new()
	seed_durab.text = "Seed Durability: " + str(selected.dna.seed_durability)
	DNAGrid.add_child(seed_durab)
	
	var root_effectivness = Label.new()
	root_effectivness.text = "Root Effectiveness: " + str(snapped(selected.dna.root_effectivnes, 2))
	DNAGrid.add_child(root_effectivness)


	var growth_threshold = Label.new()
	growth_threshold.text = "Growth Threshold: " + str(selected.dna.root_grow_threshold)
	DNAGrid.add_child(growth_threshold)

	generation.text = "Generation: " + str(selected.dna.generation)


	
	pass


func _on_panel_container_2_mouse_entered():
	Globals.cursor_obscured = true
	pass # Replace with function body.


func _on_panel_container_2_mouse_exited():
	Globals.cursor_obscured = false
	pass # Replace with function body.

func _on_copy_pressed():
	
	Globals.cursor = Globals.CursorMode.PLANT
	Globals.copy = selected.dna.duplicate(true)
	
	pass # Replace with function body.


func _handle_result(name : String):
	
	if name == "":
		return
	
	var new = NamedPlant.new()
	new.name = name
	new.dna = selected.dna.duplicate(true)
	Globals.saved_plants.append(new)

	

func _on_save_pressed():
	get_tree().paused = true	
	pop_up.visible = true
	
	pass # Replace with function body.

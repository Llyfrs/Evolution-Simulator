extends Button

"""

This script is attached to the "Kill All" button in the tool window. It is used to kill all plants, creatures, and seeds in the scene and add their energy to the lost energy pool.
Useful for when we want to start fresh or need to clear the scene when the frame rate drops too low.

"""


func _pressed():
	for plant in EnergyManager.plants:
		plant.queue_free()
		EnergyManager.add_lost_energy(plant.health + plant.energy)
	
	for creature in EnergyManager.creatures:
		creature.queue_free()
		EnergyManager.add_lost_energy(creature.health + creature.energy)
	
	for seed in EnergyManager.seeds:
		seed.queue_free()
		EnergyManager.add_lost_energy(seed.energy)

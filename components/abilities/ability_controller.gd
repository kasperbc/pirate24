extends Node
class_name AbilityController

@export var ability : Ability

func activate_ability():
	_on_ability_activate()
	
	if ability.single_use:
		GameMan.player.end_ability()

func _on_ability_activate():
	print("Ability activated!")

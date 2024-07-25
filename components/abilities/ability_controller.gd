extends PlayerController
class_name AbilityController

@export var ability : Ability

var ability_active = false

func _process_io():
	if not ability_active and is_use_just_pressed():
		activate_ability()

func activate_ability():
	ability_active = true
	_on_ability_activate()
	
	if ability.single_use:
		GameMan.player.end_ability()
	else:
		ability_active = false

func _on_ability_activate():
	print("Ability activated!")

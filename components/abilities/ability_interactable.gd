extends Interactable
class_name AbilityInteractable

@export var ability : Ability
@export var ability_controller : PackedScene

func _on_interact():
	if ability == null:
		return
	
	GameMan.player.set_ability(ability, ability_controller)

extends Interactable
class_name AbilityInteractable

@export var ability_controller : PackedScene

func _on_interact():
	if ability_controller == null:
		return
	
	GameMan.player.charge_ability(ability_controller)

func get_icon() -> CompressedTexture2D:
	return %AbilityIcon.icon

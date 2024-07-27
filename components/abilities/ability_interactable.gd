extends Interactable
class_name AbilityInteractable

@export var ability_controller : PackedScene
@export var ability_icon : CompressedTexture2D

func _on_interact():
	if ability_controller == null:
		return
	
	GameMan.player.charge_ability(ability_controller)

extends Interactable
class_name AbilityInteractable

@export var ability : Ability

func _on_interact():
	if ability == null:
		return
	
	print("Ability !! :DDD")

extends AbilityController
class_name CoffeeMachineAbilityController

func _on_ability_activate():
	print("Coffee machine!")
	
	await get_tree().create_timer(1).timeout

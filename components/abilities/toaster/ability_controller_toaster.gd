extends AbilityController
class_name ToasterAbilityController

@export var puddle_min_distance : float = 24.0
@export var broken_door_min_distance : float = 80.0

func _on_ability_activate():
	SoundManager.play_sound(AudioLib.get_sound("thud"))
	
	if not in_puddle():
		Utils.create_shaker_and_shake(player_sprite, 2.0, 0.5)
		return
	Utils.create_shaker_and_shake(player_sprite, 1.0, 0.5)
	
	for d : Door in get_tree().get_nodes_in_group("BrokenDoor"):
		if d.global_position.distance_to(player.global_position) <= broken_door_min_distance:
			if d.opened_on_start:
				d.close()
			else:
				d.open()

func in_puddle() -> bool:
	for p : Node2D in get_tree().get_nodes_in_group("WaterPuddle"):
		if p.global_position.distance_to(player.global_position) <= puddle_min_distance:
			return true
	
	return false

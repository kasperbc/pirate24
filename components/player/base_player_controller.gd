extends PlayerController
class_name BasePlayerController

@export var move_speed = 75.0

func _process_io():
	player.velocity = get_move_direction() * move_speed

func _process_animation():
	anim_state = "walk" if get_move_direction().length() != 0 else "default"

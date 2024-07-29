extends PlayerController
class_name BasePlayerController

@export var move_speed = 75.0

func _process_io():
	var _move_speed = move_speed
	if Input.is_action_pressed("adjust_direction"):
		if player.debug_mode:
			_move_speed *= 5
		else:
			_move_speed /= 5
			
	
	player.velocity = get_move_direction() * _move_speed

func _process_animation():
	if get_move_input() == Vector2.ZERO:
		anim_state = "default"
	else:
		anim_state = "walk"
		
	anim_suffix = Utils.get_anim_suffix_based_on_dir(player.direction)
	player_sprite.flip_h = true if anim_suffix == "side" and player.direction.x < 0 else false

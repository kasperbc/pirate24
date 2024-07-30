extends Area2D

func _on_body_entered(body):
	if body is not Player:
		return
	
	GameMan.level_loader.spawn_pos_override = global_position

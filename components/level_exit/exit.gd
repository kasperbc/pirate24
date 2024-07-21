extends Area2D
class_name LevelExit

func _on_body_entered(body : Node2D):
	if not body.is_in_group("Player"):
		return
	
	print("Exit triggered!")

extends Area2D

func _on_body_entered(body):
	if body is not Player:
		return
	
	if %TutorialEnemy != null:
		%TutorialEnemy.move_speed = 60

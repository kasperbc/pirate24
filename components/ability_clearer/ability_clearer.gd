extends Area2D


func _on_body_entered(body):
	if body is not Player:
		return
	
	SoundManager.play_sound(AudioLib.get_sound("big_explosion2"))
	body.uncharge_ability()

extends Area2D

func _on_body_entered(body):
	if body is not Player:
		return
	
	body.able_to_move = false
	body.velocity = Vector2.ZERO
	body.get_node("Sprite2D").animation = "spotted_side"
	
	GameMan.camera.change_zoom_smooth(0.25, 0.75)
	
	SoundManager.play_sound(AudioLib.get_sound("notice2"))
	SoundManager.stop_music(0.25)
	
	GameMan.player.get_node("Notice").visible = true
	
	await get_tree().create_timer(1).timeout
	
	GameMan.camera.target = %TutorialEnemy
	%TutorialEnemy.process_mode = Node.PROCESS_MODE_INHERIT
	
	await get_tree().create_timer(1).timeout
	
	GameMan.player.get_node("Notice").visible = false
	
	SoundManager.play_music_at_volume(AudioLib.get_sound("chase"), 6.0)
	
	GameMan.camera.target = GameMan.player
	body.able_to_move = true
	get_tree().get_first_node_in_group("TutorialLabel").activate()
	queue_free()

extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_tween().tween_property($ScreenFade, "modulate", Color.TRANSPARENT, 1.0)
	$Spaceship.velocity = Vector2.RIGHT * 5
	
	await get_tree().create_timer(2).timeout
	
	$TransformSound.play()
	
	await get_tree().create_timer(2).timeout
	
	$MoveSound.play()
	get_tree().create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN).tween_property($Spaceship, "rotation_degrees", -20, 3.0)
	get_tree().create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN).tween_property($Spaceship, "velocity", Vector2.RIGHT * 1000, 2.0)
	
	await get_tree().create_timer(4).timeout
	
	SoundManager.play_music(AudioLib.get_sound("the-last-revenant-title-theme-demo"), 0.0)
	get_tree().create_tween().tween_property($EndScreen, "modulate", Color.WHITE, 1.0)

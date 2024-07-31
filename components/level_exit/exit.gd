extends Area2D
class_name LevelExit

@export var sprite : CompressedTexture2D

var activated : bool = false

func _on_body_entered(body : Node2D):
	if not body.is_in_group("Player") or activated:
		return
	activated = true
	
	$FrontCollider.set_deferred("disabled", false)
	$Sprite2D.texture = sprite
	Utils.create_shaker_and_shake($Sprite2D)
	SoundManager.play_sound(AudioLib.get_sound("door"))
	$Sprite2D.z_index = 200
	
	await get_tree().create_timer(0.75).timeout
	GameMan.screen_fade.fade_screen_out(0.5)
	
	await get_tree().create_timer(0.5).timeout
	SoundManager.play_sound(AudioLib.get_sound("accelerate"))
	
	await get_tree().create_timer(3).timeout
	
	GameMan.music_override = ""
	GameMan.segement_override = -1
	GameMan.screen_fade.fade_screen_in(0.75)
	GameMan.level_loader.load_level(GameMan.level_loader.curr_level_res.next_level)

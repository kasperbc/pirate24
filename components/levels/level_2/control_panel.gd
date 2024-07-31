extends Interactable
class_name ControlPanel

@export var end_scene : PackedScene

var activated = false

func _on_interact():
	if activated:
		return
	
	GameMan.screen_fade.fade_screen_out(1.0)
	SoundManager.stop_music(1.0)
	
	await get_tree().create_timer(1).timeout
	
	GameMan.change_to_end_scene(end_scene)

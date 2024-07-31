extends Area2D
class_name LevelExit

func _on_body_entered(body : Node2D):
	if not body.is_in_group("Player"):
		return
	
	GameMan.screen_fade.fade_screen_out_in(0.75, 1.0)
	
	await GameMan.screen_fade.in_out_fade_halfway
	GameMan.music_override = ""
	GameMan.level_loader.load_level(GameMan.level_loader.curr_level_res.next_level)

extends Camera2D
class_name MainCamera

func _process(delta):
	position = GameMan.player.position

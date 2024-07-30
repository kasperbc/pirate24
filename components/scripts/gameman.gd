extends Node
class_name GameManager

#region Global References
var player : Player :
	get:
		if player == null:
			player = get_tree().get_first_node_in_group("Player")
		return player
	set(value):
		player = value

var level_loader : LevelLoader :
	get:
		if level_loader == null:
			level_loader = get_tree().get_first_node_in_group("LevelLoader")
		return level_loader
	set(value):
		level_loader = value

var camera : MainCamera :
	get:
		if camera == null:
			camera = get_tree().get_first_node_in_group("Camera")
		return camera
	set(value):
		camera = value

var screen_fade : ScreenFade :
	get:
		if screen_fade == null:
			screen_fade = get_tree().get_first_node_in_group("ScreenFade")
		return screen_fade
	set(value):
		screen_fade = value

var segment_label : SegmentLabel :
	get:
		if segment_label == null:
			segment_label = get_tree().get_first_node_in_group("SegmentLabel")
		return segment_label
	set(value):
		segment_label = value
#endregion

var segement_override : int = -1
var level_override : Level = null

extends Resource
class_name Level

@export var level_name : String
@export var scene : PackedScene

func _init(p_level_name = "Level", p_scene = null):
	level_name = p_level_name
	scene = p_scene

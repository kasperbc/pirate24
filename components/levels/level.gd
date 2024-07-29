extends Resource
class_name Level

@export var level_name : String
@export var scene : PackedScene
@export var next_level : Level
@export var music : String
@export var music_vol : float
@export var restart_music_on_reload : bool = false

func _init(p_level_name = "Level", p_scene = null):
	level_name = p_level_name
	scene = p_scene

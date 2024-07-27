extends Node
class_name LevelLoader

@export var default_level : Level

var curr_level : Node2D
var curr_level_res : Level

func _ready():
	load_level(default_level)

func load_level(l : Level):
	if curr_level != null:
		unload_current_level()
	
	var loaded_level = l.scene.instantiate()
	add_child(loaded_level)
	
	curr_level = loaded_level
	curr_level_res = l
	
	GameMan.player.global_position = Vector2.ZERO
	GameMan.player.reset()
	
	GameMan.camera.zoom = Vector2.ONE * 2.5

func reload_level(fade_anim : bool = false):
	if fade_anim:
		pass
	
	load_level(curr_level_res)

func unload_current_level():
	curr_level.queue_free()
	
	curr_level = null
	curr_level_res = null

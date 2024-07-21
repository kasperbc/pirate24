extends Node

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

func unload_current_level():
	curr_level.queue_free()
	
	curr_level = null
	curr_level_res = null

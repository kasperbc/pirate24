extends Node
class_name Entry

@export var load_title : bool = false
@export_group("Overrides")
@export var level : Level = null
@export var segment : float = 0
@export_group("References")
@export var main_scene : PackedScene
@export var title_scene : PackedScene

func _ready():
	if OS.has_feature("editor"):
		GameMan.segement_override = segment
		if level != null:
			GameMan.level_override = level
		
		get_tree().call_deferred("change_scene_to_packed", main_scene if not load_title else title_scene)
	else:
		get_tree().change_scene_to_packed(title_scene)

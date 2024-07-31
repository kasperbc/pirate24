extends Node
class_name Entry

@export var load_opening : bool = false
@export_group("Overrides")
@export var level : Level = null
@export var segment : float = 0
@export var skip_beginning_cutscene : bool = false
@export_group("References")
@export var main_scene : PackedScene
@export var opening_scene : PackedScene

func _ready():
	if OS.has_feature("editor"):
		GameMan.segement_override = segment
		GameMan.cutscene_seen = skip_beginning_cutscene
		if level != null:
			GameMan.level_override = level
		get_tree().call_deferred("change_scene_to_packed", main_scene if not load_opening else opening_scene)
	else:
		get_tree().change_scene_to_packed(opening_scene)

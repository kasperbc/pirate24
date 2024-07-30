extends Control
class_name Title

@export var main_scene : PackedScene

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(main_scene)

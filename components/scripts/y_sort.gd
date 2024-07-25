extends Node2D
class_name YSort

@export var target : Node2D

@onready var base_z = target.z_index

func _process(delta):
	target.z_index = base_z if global_position.y < GameMan.player.global_position.y else 150

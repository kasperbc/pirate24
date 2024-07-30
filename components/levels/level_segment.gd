extends Node2D
class_name LevelSegment

@export var segment_id : int
@export_multiline var segment_name : String = "Segement 1-1\n\nSegment Name"
@export_group("References")
@export var level : Node2D
@export var bounds : LevelBounds
@export var player_start_point : Node2D

func _ready():
	add_to_group("LevelSegment")

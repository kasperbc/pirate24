extends Node
class_name GameManager

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var level_loader : LevelLoader = get_tree().get_first_node_in_group("LevelLoader")
@onready var camera : MainCamera = get_tree().get_first_node_in_group("Camera")
@onready var screen_fade : ScreenFade = get_tree().get_first_node_in_group("ScreenFade")
@onready var segment_label : SegmentLabel = get_tree().get_first_node_in_group("SegmentLabel")

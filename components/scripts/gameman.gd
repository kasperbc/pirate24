extends Node
class_name GameManager

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var level_loader : LevelLoader = get_tree().get_first_node_in_group("LevelLoader")

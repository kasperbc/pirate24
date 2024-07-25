extends Node
class_name PlayerController

@export_group("Parameters")
@export var able_to_interact : bool = true

@export_group("Animation")
@export var sprite_frames : SpriteFrames

var player : Player
var player_sprite : AnimatedSprite2D
var dt : float

func _process(delta):
	dt = delta

func process_controller():
	_process_io()
	_process_animation()

func _process_io():
	pass

func _process_animation():
	pass

func get_move_input() -> Vector2:
	return player.move_input

func get_move_direction() -> Vector2:
	return player.move_input.normalized()

func is_use_just_pressed() -> bool:
	return Input.is_action_just_pressed("use_ability")

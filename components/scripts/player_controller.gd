extends Node
class_name PlayerController

@export_group("Parameters")
@export var able_to_interact : bool = true
@export var freeze_direction : bool = true

@export_group("Animation")
@export var sprite_frames : SpriteFrames

var player : Player
var player_sprite : AnimatedSprite2D
var dt : float

var anim_state : String
var anim_suffix : String

var cycle : int = 0

func activate():
	_on_activate()

func _on_activate():
	pass

func _process(delta):
	dt = delta

func process_controller():
	_process_io()
	_process_animation()
	apply_animation()
	cycle += 1

func _process_io():
	pass

func _process_animation():
	pass

func apply_animation():
	var state = anim_state if not anim_state.is_empty() else "default"
	
	var state_with_suffix = "%s_%s" % [state, anim_suffix]
	
	if not anim_suffix.is_empty() and player_sprite.sprite_frames.has_animation(state_with_suffix):
		player_sprite.animation = state_with_suffix
	else:
		player_sprite.animation = state

func get_move_input() -> Vector2:
	return player.move_input

func get_move_direction() -> Vector2:
	return player.move_input.normalized()

func is_use_just_pressed() -> bool:
	return Input.is_action_just_pressed("use_ability") and cycle != 0

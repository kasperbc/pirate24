extends Node
class_name Shaker

var shake_target

var shake_intensity
var shake_duration

var shake_base_position : Vector2
var shaking : bool = false
var time_shaken : float

func _physics_process(delta):
	if shaking:
		time_shaken += delta
		shake()

func shake():
	if time_shaken > shake_duration:
		queue_free()
		return
	
	var time_normalized = 1 - (time_shaken / shake_duration)
	
	var intensity = shake_intensity * time_normalized
	var pos = shake_base_position
	pos.x += randf_range(-intensity, intensity)
	pos.y += randf_range(-intensity, intensity)
	
	shake_target.global_position = pos

func start_shake(target : Node, intensity = 1.0, duration = 1.0):
	shake_target = target
	shake_intensity = intensity
	shake_duration = duration
	
	time_shaken = 0
	shaking = true
	
	shake_base_position = target.global_position

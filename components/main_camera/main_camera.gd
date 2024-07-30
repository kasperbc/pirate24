extends Camera2D
class_name MainCamera

signal transition_complete

const CAM_PAN_SPEED : float = 300.0

var transitioning : bool = false
var zooming : bool = false

var time_since_start : float = 0.0

var cam_offset : Vector2 = Vector2.ZERO

@onready var target : Node2D = GameMan.player

func _ready():
	global_position = target.global_position

func _process(delta):
	time_since_start += delta
	
	if not transitioning:
		global_position = global_position.lerp(target.global_position + cam_offset, 0.1)
		if time_since_start < 1.0:
			global_position = target.global_position + cam_offset
	
	if GameMan.player.velocity == Vector2.ZERO:
		var cam_input_dir = Input.get_vector("pan_camera_left", "pan_camera_right", "pan_camera_up", "pan_camera_down")
		cam_offset += cam_input_dir * CAM_PAN_SPEED * delta
		
		var _target_pos = target.global_position + cam_offset
		var target_pos_diff = _target_pos - get_closest_limit_pos(_target_pos, get_curr_segment_limits())
		if target_pos_diff != Vector2.ZERO:
			cam_offset -= target_pos_diff
	else:
		cam_offset = Vector2.ZERO

#region Limits

func set_limit_to_curr_segment_bounds():
	set_limits(get_curr_segment_limits())

func set_limits(to : Vector4):
	limit_left = to.x
	limit_right = to.y
	limit_bottom = to.z
	limit_top = to.w

func get_curr_segment_limits() -> Vector4:
	return get_limits_from_bounds(GameMan.level_loader.curr_level_seg.bounds)

func get_limits_from_bounds(bounds : LevelBounds) -> Vector4:
	var bounds_size = bounds.size
	var bounds_center = bounds.global_position
	
	var result = Vector4.ZERO
	
	result.x = bounds_center.x - (bounds_size.x / 2)
	result.y = bounds_center.x + (bounds_size.x / 2)
	result.z = bounds_center.y + (bounds_size.y / 2)
	result.w = bounds_center.y - (bounds_size.y / 2)
	
	return result

func trans_to_limits(new_limits : Vector4, duration = 2.0):
	transitioning = true
	
	var position = get_closest_limit_pos(global_position, new_limits)
	
	var limited_pos = get_screen_center_position()
	limit_left = -1000000
	limit_right = 1000000
	limit_bottom = 1000000
	limit_top = -1000000
	global_position = limited_pos
	
	var t = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "global_position", position, duration)
	
	await t.finished
	
	set_limits(new_limits)
	
	transitioning = false
	transition_complete.emit()

func get_closest_limit_pos(from : Vector2, limits : Vector4) -> Vector2:
	var viewport_size = get_viewport_rect().size / zoom
	
	limits.x += viewport_size.x / 2
	limits.y -= viewport_size.x / 2
	limits.z -= viewport_size.y / 2
	limits.w += viewport_size.y / 2
	
	from.x = clamp(from.x, limits.x, limits.y)
	from.y = clamp(from.y, limits.w, limits.z)
	
	return from

#endregion

func change_zoom_smooth(offset : float, duration : float):
	if zooming:
		return
	zooming = true
	
	var t = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CIRC)
	t.tween_property(GameMan.camera, "zoom", Vector2.ONE * 2.5 + Vector2.ONE * offset, duration)
	
	await t.finished
	
	zooming = false

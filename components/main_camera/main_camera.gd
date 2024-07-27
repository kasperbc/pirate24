extends Camera2D
class_name MainCamera

signal transition_complete

var transitioning : bool = false

func _process(delta):
	if not transitioning:
		position = GameMan.player.position

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

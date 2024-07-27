class_name Utils

static func get_anim_suffix_based_on_dir(dir : Vector2) -> String:
	return "side" if dir == Vector2.RIGHT or dir == Vector2.LEFT else "down" if dir == Vector2.DOWN else "up"

static func create_shaker_and_shake(target : Node2D, intensity : float = 1.0, duration : float = 1.0):
	var shaker = Shaker.new()
	target.add_child(shaker)
	shaker.start_shake(target, intensity, duration)

class_name Utils

static func get_anim_suffix_based_on_dir(dir : Vector2) -> String:
	return "side" if dir == Vector2.RIGHT or dir == Vector2.LEFT else "down" if dir == Vector2.DOWN else "up"

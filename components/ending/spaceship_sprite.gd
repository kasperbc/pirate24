extends Sprite2D
class_name SpaceshipSprite

func _process(delta):
	position.y = sin(Time.get_unix_time_from_system()) * 5

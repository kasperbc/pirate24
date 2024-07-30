extends AnimatedSprite2D

@onready var base_pos : Vector2 = position

func _process(delta):
	if position.distance_to(base_pos) > 8.0:
		position = base_pos

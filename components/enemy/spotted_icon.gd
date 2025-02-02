extends Sprite2D

func _ready():
	scale = Vector2.ZERO

func _process(delta):
	global_rotation = 0

func _on_spot():
	global_position = get_parent().global_position + Vector2.UP * 20
	
	var t = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_ELASTIC)
	
	t.tween_property(self, "scale", Vector2.ONE, 0.75)

extends Label
class_name SegmentLabel

func _ready():
	modulate = Color(1,1,1,0)

func show_text(new_text : String):
	text = new_text
	modulate = Color(1,1,1,0)
	
	get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 1.5)
	
	await get_tree().create_timer(4).timeout
	
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,0), 1.5)

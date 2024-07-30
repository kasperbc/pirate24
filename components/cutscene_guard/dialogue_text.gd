extends Label

func show_dialogue(_text : String, dur : float):
	text = _text
	
	visible_ratio = 0
	get_tree().create_tween().tween_property(self, "visible_ratio", 1, dur)

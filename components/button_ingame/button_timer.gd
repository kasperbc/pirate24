extends Label

@export var button : ButtonInteractable


func _process(delta):
	rotation = -button.rotation
	
	if button.time_left > 0.0:
		text = str(round(button.time_left * 10) / 10)
	else:
		text = ""

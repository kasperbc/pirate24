extends Interactable
class_name ButtonInteractable

signal pressed

@export var door : Door

func _on_interact():
	pressed.emit()
	
	if door != null:
		door.open()

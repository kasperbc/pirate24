extends Interactable
class_name ButtonInteractable

signal pressed

func _on_interact():
	pressed.emit()

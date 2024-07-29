extends Interactable
class_name ButtonInteractable

signal pressed

@export var door : Door

func _on_interact():
	pressed.emit()
	
	SoundManager.play_sound(AudioLib.get_sound("click"))
	
	if door != null:
		door.open()

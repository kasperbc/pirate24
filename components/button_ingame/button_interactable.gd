extends Interactable
class_name ButtonInteractable

signal pressed
signal timeout

@export var door : Door
@export_group("Timing")
@export var timed : bool = false
@export var time : float = 10.0

var time_left : float = 0.0

func _on_interact():
	pressed.emit()
	
	SoundManager.play_sound(AudioLib.get_sound("click"))
	
	if door != null:
		if door.opened_on_start:
			door.close()
		else:
			door.open()
		
	if timed:
		time_left = time

func _process(delta):
	if time_left <= 0.0:
		time_left = 0.0
		return
	
	time_left -= delta
	if time_left <= 0.0:
		_on_time_out()

func _on_time_out():
	if door != null:
		if door.opened_on_start:
			door.open()
		else:
			door.close()
	
	timeout.emit()

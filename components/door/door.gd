extends StaticBody2D
class_name Door

@export var broken : bool = false
@export var opened_on_start : bool = false

func _ready():
	if opened_on_start:
		%Sprite2D.play("open")
		%CollisionShape2D.disabled = true

func open():
	%Sprite2D.play("open")
	%CollisionShape2D.disabled = true
	
	_on_door_change()

func close():
	%Sprite2D.play("default")
	%CollisionShape2D.disabled = false
	
	_on_door_change()

func _on_door_change():
	Utils.create_shaker_and_shake(%Sprite2D, 2.0)
	
	var sound = "shock"
	if not broken:
		sound = "door"
	SoundManager.play_sound(AudioLib.get_sound(sound))

extends StaticBody2D
class_name Door

var broken : bool = false

func open():
	%Sprite2D.play("open")
	Utils.create_shaker_and_shake(%Sprite2D, 2.0)
	%CollisionShape2D.disabled = true
	
	var sound = "shock"
	if not broken:
		sound = "thud"
	SoundManager.play_sound(AudioLib.get_sound(sound))

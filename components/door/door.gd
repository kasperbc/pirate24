extends StaticBody2D
class_name Door

func open():
	%Sprite2D.play("open")
	Utils.create_shaker_and_shake(%Sprite2D, 2.0)
	%CollisionShape2D.disabled = true

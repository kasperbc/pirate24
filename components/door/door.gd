extends StaticBody2D
class_name Door

func open():
	%Sprite2D.play("open")
	
	await get_tree().create_timer(2.3).timeout
	
	Utils.create_shaker_and_shake(%Sprite2D, 1.5)
	%CollisionShape2D.disabled = true

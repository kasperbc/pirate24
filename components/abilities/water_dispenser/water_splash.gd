extends AbilityAttack
class_name WaterStillAttack

func _attack(target : EnemyBehvaiour):
	target.stun(5)

func _on_fadeout():
	monitoring = false

func _on_body_entered(body):
	if body is EnemyBehvaiour:
		_attack(body)
		monitoring = false

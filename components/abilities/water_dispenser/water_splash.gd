extends AbilityAttack
class_name WaterStillAttack

var ignore_list : Array[EnemyBehvaiour]

func _attack(target : EnemyBehvaiour):
	#if ignore_list.has(target):
	#	return
	
	#ignore_list.append(target)
	target.stun(5)

func _on_fadeout():
	monitoring = false

func _on_body_entered(body):
	if body is EnemyBehvaiour:
		_attack(body)
		set_deferred("monitoring", false)

extends AbilityAttack
class_name WaterStillAttack

var ignore_list : Array[EnemyBehvaiour]

func _attack(target : EnemyBehvaiour):
	SoundManager.play_sound(AudioLib.get_sound("spill"))
	target.stun(5, EnemyBehvaiour.StunSource.DEFAULT)

func _on_fadeout():
	monitoring = false

func _on_body_entered(body):
	if body is EnemyBehvaiour:
		_attack(body)
		set_deferred("monitoring", false)

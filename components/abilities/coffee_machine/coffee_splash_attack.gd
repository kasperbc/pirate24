extends AbilityAttack
class_name CoffeeSpillAttack

func _attack(target : EnemyBehvaiour):
	SoundManager.play_sound(AudioLib.get_sound("spill"))
	target.stun(7.5, EnemyBehvaiour.StunSource.COFFEE)

extends AbilityAttack
class_name CoffeeSpillAttack

func _attack(target : EnemyBehvaiour):
	target.stun(7.5, EnemyBehvaiour.StunSource.COFFEE)

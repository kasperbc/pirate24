extends AbilityAttack
class_name CoffeeSpillAttack

func _attack(target : EnemyBehvaiour):
	target.stun(5, EnemyBehvaiour.StunSource.COFFEE)

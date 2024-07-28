extends AbilityController
class_name CustomPlayerController

@export var enemy_distance_req : float = 16.0
@export var push_force : float = 100.0
@export var friction : float = 100.0

func _process_io():
	super()
	
	var nearest_enemy = get_nearest_valid_enemy()
	if nearest_enemy != null:
		on_push(nearest_enemy)
	
	player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * dt)

func get_nearest_valid_enemy() -> EnemyBehvaiour:
	var closest : EnemyBehvaiour = null
	var closest_dist : float = enemy_distance_req
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy is not EnemyBehvaiour:
			continue
		
		if player.global_position.distance_to(enemy.global_position) <= closest_dist:
			closest = enemy
	
	return closest

func on_push(origin : EnemyBehvaiour):
	var _dir = Vector2.UP.rotated(origin.rotation)
	
	player.velocity = _dir * push_force

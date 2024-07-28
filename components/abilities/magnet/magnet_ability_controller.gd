extends AbilityController
class_name MagnetAbilityController

var target_panel : Node2D = null
var speed : float = 0.0

func _on_activate():
	super()
	target_panel = find_closest_magnet_panel()

func find_closest_magnet_panel() -> Node2D:
	var closest : Node2D = null
	var closest_dist : float = 1000000.0
	
	%PanelCast.global_position = player.global_position
	
	for panel : Node2D in get_tree().get_nodes_in_group("MagnetPanel"):
		%PanelCast.target_position = %PanelCast.to_local(panel.global_position)
		
		%PanelCast.force_raycast_update()
		
		if %PanelCast.is_colliding():
			continue
		
		if player.global_position.distance_to(panel.global_position) < closest_dist:
			closest = panel
			closest_dist = player.global_position.distance_to(panel.global_position)
	
	return closest

func _on_ability_activate():
	if target_panel == null:
		return
	
	var _dir = player.global_position.direction_to(target_panel.global_position)
	dir = _dir
	Utils.create_shaker_and_shake(player_sprite, 0.5, 0.5)
	await get_tree().create_timer(0.5).timeout
	
	var last_pos : Vector2 = player.global_position
	while player.global_position.distance_to(target_panel.global_position) > 10.0:
		_dir = player.global_position.direction_to(target_panel.global_position)
		player.velocity = _dir * speed
		
		speed = clamp(speed + 500.0 * pdt, 0.0, 500.0)
		
		if player.global_position.distance_to(last_pos) < 16.0 and speed > 400.0:
			break
		
		await get_tree().physics_frame
	
	player.velocity = Vector2.ZERO
	Utils.create_shaker_and_shake(player_sprite, 2.0, 0.75)
	
	target_panel.get_node("Particles/PosParticleBurst").emitting = true
	target_panel.get_node("Particles/NegParticleBurst").emitting = true

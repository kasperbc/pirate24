@tool
extends Node2D

@export var enemy : EnemyBehvaiour

var last_redraw : float = 0

func _process(delta):
	last_redraw += delta
	if last_redraw > 0.5:
		last_redraw = 0
		queue_redraw()

func _draw():
	if enemy == null or not Engine.is_editor_hint():
		return
	
	for p in get_player_ray_positions():
		draw_line(Vector2.ZERO, p, Color(1,1,0,0.25))

func get_player_ray_positions() -> Array:
	var positions = []
	
	for i in EnemyBehvaiour.PLAYER_CHECK_RAY_COUNT + 1:
		var angle = ((float(i) / EnemyBehvaiour.PLAYER_CHECK_RAY_COUNT) - 0.5) * 2 * enemy.detection_angle
		var pos = Vector2(0, -enemy.detection_distance).rotated(deg_to_rad(angle))
		positions.append(pos)
	
	return positions

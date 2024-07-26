extends CharacterBody2D
class_name EnemyBehvaiour

const BASE_SPEED : float = 60.0
const PLAYER_CHECK_RAY_COUNT : int = 24 # it actually makes one more :3

@export_group("Movement")
@export var move_speed : float = BASE_SPEED
@export var wall_turn_distance : float = 32.0
@export var wait_time : float = 5.0

@export_group("Player Detection")
@export var detection_angle : float = 30.0
@export var detection_distance : float = 80.0

var player_check_rays : Array[RayCast2D]

func _ready():
	%WallCheck.target_position = Vector2(0, -wall_turn_distance)
	
	create_player_check_rays()

func create_player_check_rays():
	var positions = get_player_ray_positions()
	
	for p in positions:
		var ray_pos = p
		
		var ray = RayCast2D.new()
		%PlayerCheckGroup.add_child(ray)
		ray.collision_mask = 0x3
		ray.target_position = ray_pos
		
		player_check_rays.append(ray)

func get_player_ray_positions() -> Array:
	var positions = []
	
	for i in PLAYER_CHECK_RAY_COUNT + 1:
		var angle = ((float(i) / PLAYER_CHECK_RAY_COUNT) - 0.5) * 2 * detection_angle
		var pos = Vector2(0, -detection_distance).rotated(deg_to_rad(angle))
		positions.append(pos)
	
	return positions

func get_player_ray_collision_positions() -> Array:
	var positions = []
	var default_positions = get_player_ray_positions()
	
	var i = 0
	for r : RayCast2D in player_check_rays:
		if not r.is_colliding():
			positions.append(default_positions[i])
			i += 1
			continue
		
		if not r.get_collision_mask_value(2):
			positions.append(default_positions[i])
			i += 1
			continue
		
		positions.append(to_local(r.get_collision_point()))
		i += 1
	
	return positions

func _process(delta):
	process_animation()
	draw_light_poly()

func draw_light_poly():
	var vertices = [Vector2(0,0)]
	vertices.append_array(get_player_ray_collision_positions())
	
	%LightPoly.polygon = PackedVector2Array(vertices)

func _physics_process(delta):
	velocity = transform.x.rotated(deg_to_rad(-90)) * move_speed
	
	if %WallCheck.get_collider() != null:
		rotate(deg_to_rad(180))
	
	if try_detect_player():
		GameMan.level_loader.reload_level()
	
	move_and_slide()

func process_animation():
	var anim = "default"
	if velocity.length() != 0:
		anim = "walk"
		%Sprite2D.speed_scale = move_speed / BASE_SPEED
	
	%Sprite2D.animation = anim

func try_detect_player() -> bool:
	for r in player_check_rays:
		var collider = r.get_collider()
		
		if collider != null and collider.is_in_group("Player") and not collider.has_ability():
			return true
	
	return false

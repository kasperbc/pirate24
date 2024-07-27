extends CharacterBody2D
class_name EnemyBehvaiour

const BASE_SPEED : float = 60.0
const PLAYER_CHECK_RAY_COUNT : int = 24 # it actually makes one more :3
const LIGHT_POLY_COLOR : Color = Color(1,0,0,0.33)

@export_group("Movement")
@export var move_speed : float = BASE_SPEED
@export var wall_turn_distance : float = 32.0
@export var wait_time : float = 2.0

@export_group("Player Detection")
@export var detection_angle : float = 30.0
@export var detection_distance : float = 80.0

var player_check_rays : Array[RayCast2D]

var stunned : bool = false
var waiting : bool = false
var spotted : bool = false

func _ready():
	%WallCheck.target_position = Vector2(0, -wall_turn_distance)
	%LightPoly.color = LIGHT_POLY_COLOR
	
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
	if stunned or GameMan.player.spotted:
		return
	
	velocity = transform.x.rotated(deg_to_rad(-90)) * move_speed if not waiting else Vector2.ZERO
	
	if %WallCheck.get_collider() != null and not waiting:
		turn_around()
	
	if try_detect_player():
		GameMan.player.on_spotted()
		spotted = true
		%SpottedIcon._on_spot()
	
	move_and_slide()

func turn_around():
	if waiting:
		return
	
	if wait_time > 0:
		waiting = true
		await get_tree().create_timer(wait_time).timeout
	
	rotate(deg_to_rad(180))
	
	for i in 2:
		await get_tree().physics_frame
	
	waiting = false

func process_animation():
	if not stunned:
		%Sprite2D.global_position = global_position
	
	var anim = "default"
	if velocity.length() != 0:
		anim = "walk"
		%Sprite2D.speed_scale = move_speed / BASE_SPEED
	if spotted:
		anim = "spotted"
	
	var dir_vec2 = Vector2.UP.rotated(rotation)
	
	
	var suffix = Utils.get_anim_suffix_based_on_dir(dir_vec2)
	anim += "_%s" % suffix
	
	%Sprite2D.flip_h = dir_vec2.x < 0
	
	%Sprite2D.animation = anim

func try_detect_player() -> bool:
	for r in player_check_rays:
		var collider = r.get_collider()
		
		if collider != null and collider.is_in_group("Player") and not collider.has_ability():
			return true
	
	return false

func stun(duration : float):
	stunned = true
	
	Utils.create_shaker_and_shake(%Sprite2D, 1.0, duration * 0.75)
	
	get_tree().create_tween().tween_property(%LightPoly, "color", Color(0,0,0,0), duration * 0.1)

	await get_tree().create_timer(duration * 0.75).timeout
	
	var t = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	t.tween_property(%LightPoly, "color", LIGHT_POLY_COLOR, duration * 0.2)
	
	await get_tree().create_timer(duration * 0.25).timeout
	
	stunned = false
	%DialogueText.show_forget_dialogue()

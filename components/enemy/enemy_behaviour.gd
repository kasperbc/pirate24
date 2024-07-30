extends CharacterBody2D
class_name EnemyBehvaiour

enum StunSource {
	DEFAULT = 0,
	COFFEE = 1
}

enum MoveType {
	BACK_AND_FORTH = 0,
	TURN_IN_PLACE = 1,
	SET_POSITIONS = 2
}

const BASE_SPEED : float = 60.0
const PLAYER_CHECK_RAY_COUNT : int = 24 # it actually makes one more :3
const LIGHT_POLY_COLOR : Color = Color(1,0,0,0.33)

@export var move_type : MoveType
@export_group("General")
@export var move_speed : float = BASE_SPEED
@export var wait_time : float = 2.0

@export_group("Back and forth")
@export var wall_turn_distance : float = 32.0

@export_group("Turning")
@export var turn_positions : Array[float]

@export_group("Set Positions")
@export var move_positions : Array[Vector2]

@export_group("Player Detection")
@export var detection_angle : float = 30.0
@export var detection_distance : float = 80.0

var player_check_rays : Array[RayCast2D]

var stunned : bool = false
var stun_src : StunSource = 0

var waiting : bool = false
var spotted : bool = false

var curr_pos_index : int = 0

var move_positions_local : Array[Vector2]

var pdt : float
@onready var last_ability_dialogue_time : float = 0

func _ready():
	%WallCheck.target_position = Vector2(0, -wall_turn_distance)
	%LightPoly.color = LIGHT_POLY_COLOR
	%Sprite2D.visible = true
	%Sprite2D.play("default_side")
	
	for p in move_positions:
		move_positions_local.append(to_global(p))
	
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
	
	match move_type:
		0:
			process_back_and_forth()
		1:
			process_turn_in_place()
		2:
			process_set_positions()
	
	if try_detect_player():
		GameMan.player.on_spotted()
		spotted = true
		%SpottedIcon._on_spot()
	
	move_and_slide()
	
	try_play_ability_dialogue()

func try_play_ability_dialogue():
	if not GameMan.player.has_ability() or GameMan.player.global_position.distance_to(global_position) > 100.0:
		return
	
	if Time.get_unix_time_from_system() - last_ability_dialogue_time < 10:
		return
	
	%DialogueText.show_dialogue(GameMan.player.ability.enemy_dialogues.pick_random())

#region Back-and-forth

func process_back_and_forth():
	velocity = transform.x.rotated(deg_to_rad(-90)) * move_speed if not waiting else Vector2.ZERO
	
	if %WallCheck.get_collider() != null and not waiting:
		turn_around()

func turn_around():
	if waiting:
		return
	
	waiting = true
	if wait_time > 0:
		await get_tree().create_timer(wait_time).timeout
	
	var target_rotation = rotation + PI
	
	
	while abs(angle_difference(rotation, target_rotation)) > 0.01:
		rotation = lerp_angle(rotation, target_rotation, 0.1)
		await get_tree().physics_frame
	
	rotation = target_rotation
	#for x in 2:
	# 	await get_tree().process_frame
	
	waiting = false

#endregion

#region Turn in place

func process_turn_in_place():
	var target_angle = deg_to_rad(turn_positions[curr_pos_index])
	
	rotation = lerp_angle(rotation, target_angle, move_speed / 1000)
	
	if angle_difference(rotation, target_angle) < 0.1:
		move_pos_index(turn_positions)

#endregion

#region Set Positions

func process_set_positions():
	var target_pos = move_positions[curr_pos_index]
	
	if not waiting:
		var dir_to_target = global_position.direction_to(target_pos)
		if dir_to_target != Vector2.ZERO:
			rotation = lerp_angle(rotation, dir_to_target.rotated(deg_to_rad(90)).angle(), 0.1)
			velocity = dir_to_target * move_speed
	else:
		velocity = Vector2.ZERO
	
	if global_position.distance_to(target_pos) < 2:
		move_pos_index(move_positions)

#endregion

func move_pos_index(array : Array):
	if waiting:
		return
	
	if wait_time > 0:
		waiting = true
		await get_tree().create_timer(wait_time).timeout
	
	curr_pos_index += 1
	if curr_pos_index >= array.size():
		curr_pos_index = 0
	
	waiting = false

func process_animation():
	if not stunned:
		%Sprite2D.global_position = global_position
	
	var anim = "default"
	if velocity.length() != 0:
		anim = "walk"
		%Sprite2D.speed_scale = move_speed / BASE_SPEED
	if stunned:
		anim = "stunned"
		if stun_src == StunSource.COFFEE:
			anim = "stunned_coffee"
	if spotted:
		anim = "spotted"
	
	var dir_vec2 = Vector2.UP.rotated(rotation)
	var suffix = Utils.get_anim_suffix_based_on_dir(dir_vec2)
	anim += "_%s" % suffix
	
	%Sprite2D.flip_h = dir_vec2.x < 0
	%Sprite2D.animation = anim
	
	if stunned and stun_src == StunSource.COFFEE:
		%SmokeParticle.emitting = true
		%SmokeParticle.z_index = -61 if dir_vec2.y < 0.1 else 0
		%SmokeParticle.global_rotation = 0
	else:
		%SmokeParticle.emitting = false

func try_detect_player() -> bool:
	for r in player_check_rays:
		var collider = r.get_collider()
		
		if collider != null and collider.is_in_group("Player") and not collider.has_ability() and not collider.transforming_end:
			return true
	
	return false

func stun(duration : float, source : StunSource = StunSource.DEFAULT):
	stunned = true
	stun_src = source
	
	Utils.create_shaker_and_shake(%Sprite2D, 1.0, duration * 0.75)
	
	get_tree().create_tween().tween_property(%LightPoly, "color", Color(0,0,0,0), duration * 0.1)

	await get_tree().create_timer(duration * 0.75).timeout
	
	var t = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	t.tween_property(%LightPoly, "color", LIGHT_POLY_COLOR, duration * 0.2)
	
	await get_tree().create_timer(duration * 0.25).timeout
	
	stunned = false
	%DialogueText.show_forget_dialogue()

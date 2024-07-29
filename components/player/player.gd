extends CharacterBody2D
class_name Player

signal ability_charging_started
signal charged
signal transformed
signal untransform_started
signal untransformed

const PLAYER_HEIGHT : int = 27
const DEFAULT_ANIM : StringName = "default_side"
const INTERACTION_RANGE : float = 32.0

@export var default_controller : PlayerController

var controller : PlayerController
var ability : AbilityData

var move_input : Vector2
var closest_interactable : Interactable

var charged_controller : PackedScene
var charged_ability : AbilityData

var transforming : bool = false
var charging : bool = false

var able_to_move : bool = true
var spotted : bool = false
var direction : Vector2

var debug_mode : bool = false

func _ready():
	set_controller(default_controller)

func _process(delta):
	move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if move_input != Vector2.ZERO and not controller.freeze_direction and input_enabled():
		direction = get_direction(move_input)
	
	if controller.able_to_interact:
		interaction_update()
	
	if has_ability_charged() and Input.is_action_just_pressed("use_ability"):
		transform()
	
	if input_enabled():
		controller.process_controller()
	
	if Input.is_action_just_pressed("toggle_debug") and OS.has_feature("editor"):
		debug_mode = !debug_mode
		%CollisionShape.disabled = debug_mode

func get_direction(move_vector : Vector2) -> Vector2:
	if abs(move_vector.y) > abs(move_vector.x):
		return Vector2.UP if move_vector.y < 0 else Vector2.DOWN
	else:
		return Vector2.LEFT if move_vector.x < 0 else Vector2.RIGHT
	

func _physics_process(delta):
	move_and_slide()

#region Interaction

func interaction_update():
	closest_interactable = get_closest_interactable()
	
	if Input.is_action_just_pressed("interact"):
		try_interact()

func get_closest_interactable() -> Interactable:
	var interactables = get_tree().get_nodes_in_group("Interactable")
	if len(interactables) == 0:
		return null
	
	var closest : Interactable = null
	var closest_dist : float = 100000 # if this doesnt work add one more zero to it
	
	for itr in interactables:
		if itr is not Interactable:
			continue
		
		var dist = global_position.distance_to(itr.global_position)
		
		if dist > closest_dist or dist > INTERACTION_RANGE:
			continue
		
		%InteractionWallCheck.target_position = to_local(itr.global_position)
		if %InteractionWallCheck.is_colliding():
			continue
		
		closest_dist = dist
		closest = itr
	
	return closest

func try_interact():
	if closest_interactable == null:
		return
	
	closest_interactable.interact()

#endregion

#region Abilities

func charge_ability(new_controller : PackedScene, new_ability : AbilityData):
	if charged_controller == controller:
		print("This ability is already charged!")
		return
	
	
	charging = true
	velocity = Vector2.ZERO
	
	ability_charging_started.emit()
	
	%Sprite2D.play("gain_ability_%s" % Utils.get_anim_suffix_based_on_dir(direction))
	
	SoundManager.play_sound(AudioLib.get_sound("short_boom"))
	await get_tree().create_timer(0.2).timeout
	
	var shaker = Shaker.new()
	%Sprite2D.add_child(shaker)
	shaker.start_shake(%Sprite2D, 0.65)
	
	%ShadowParticlesBack.amount_ratio = 1
	%ShadowParticlesFront.amount_ratio = 1
	
	var t1 = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
	var t2 = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
	
	t1.tween_property(%ShadowParticlesBack, "amount_ratio", 0, 4)
	t2.tween_property(%ShadowParticlesFront, "amount_ratio", 0, 4)
	
	SoundManager.play_sound_with_pitch(AudioLib.get_sound("expansion_collect"), 0.5)
	
	await get_tree().create_timer(1).timeout
	
	if not charging:
		return
	
	charged_controller = new_controller
	charged_ability = new_ability
	charging = false
	%Sprite2D.play(DEFAULT_ANIM)
	print("Charged ability!")
	charged.emit()

func uncharge_ability():
	if not has_ability_charged():
		print("No ability charged!")
		return
	
	charged_controller = null
	charged_ability = null

func transform():
	if has_ability():
		push_error("Cannot activate ability another ability is active!")
		return
	
	if not input_enabled():
		return
	
	transforming = true
	velocity = Vector2.ZERO
	
	SoundManager.play_sound(AudioLib.get_sound("alien_sound"))
	SoundManager.play_sound(AudioLib.get_sound("thud"))
	
	%Sprite2D.play("transform_%s" % Utils.get_anim_suffix_based_on_dir(direction))
	
	GameMan.camera.change_zoom_smooth(0.25, 1.0)
	
	await get_tree().create_timer(1.2).timeout
	
	%TransformPreviewSprite.visible = true
	%TransformPreviewSprite.texture = get_ability_sprite_from_dir(charged_ability)
	%TransformPreviewSprite.flip_h = true if direction == Vector2.LEFT else false
	%TransformPreviewSprite.offset = Vector2(0, (PLAYER_HEIGHT - charged_ability.height) / 2)
	%TransformPreviewSprite.modulate = Color(0,0,0,1)
	%TransformPreviewSprite.scale = Vector2(0,1)
	
	var sprite_t = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	sprite_t.set_trans(Tween.TRANS_CIRC)
	sprite_t.tween_property(%TransformPreviewSprite, "scale", Vector2.ONE, 0.5)
	
	SoundManager.play_sound(AudioLib.get_sound("thud"))
	SoundManager.play_sound(AudioLib.get_sound("transform_into"))
	
	await get_tree().create_timer(0.5).timeout
	
	var sprite_t2 = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	sprite_t2.set_trans(Tween.TRANS_CIRC)
	sprite_t2.tween_property(%TransformPreviewSprite, "modulate", Color(0,0,0,0), 1.0)
	
	GameMan.camera.change_zoom_smooth(0, 0.75)
	
	if not has_ability_charged():
		end_transform()
		return
	
	var new_controller = charged_controller.instantiate()
	add_child(new_controller)
	set_controller(new_controller)
	ability = charged_ability
	
	charged_controller = null
	charged_ability = null
	
	end_transform()
	transformed.emit()

func end_transform():
	transforming = false

func end_ability():
	if not has_ability():
		return
	
	transforming = true
	
	untransform_started.emit()
	
	controller.queue_free()
	set_controller(default_controller)
	
	%Sprite2D.play_backwards("transform_%s" % Utils.get_anim_suffix_based_on_dir(direction))
	
	%TransformPreviewSprite.visible = true
	%TransformPreviewSprite.texture = get_ability_sprite_from_dir(ability, false)
	%TransformPreviewSprite.flip_h = true if direction == Vector2.LEFT else false
	%TransformPreviewSprite.offset = Vector2(0, (PLAYER_HEIGHT - ability.height) / 2)
	%TransformPreviewSprite.modulate = Color(1,1,1,1)
	%TransformPreviewSprite.scale = Vector2(1,1)
	
	var sprite_t1 = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	sprite_t1.set_trans(Tween.TRANS_CIRC)
	sprite_t1.tween_property(%TransformPreviewSprite, "modulate", Color(0,0,0,1), 0.3)
	
	SoundManager.play_sound(AudioLib.get_sound("short_boom"))
	
	await get_tree().create_timer(0.45).timeout
	
	
	var sprite_t2 = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	sprite_t2.set_trans(Tween.TRANS_CIRC)
	sprite_t2.tween_property(%TransformPreviewSprite, "scale", Vector2(0,1), 0.45)
	
	SoundManager.play_sound(AudioLib.get_sound("thud"))
	SoundManager.play_sound(AudioLib.get_sound("transform_outof"))
	
	%TransformPreviewSprite.modulate = Color(0,0,0,1)
	
	await get_tree().create_timer(1.2).timeout
	
	transforming = false
	ability = null
	
	untransformed.emit()

func has_ability() -> bool:
	return controller is not BasePlayerController

func has_ability_charged():
	return charged_controller != null

func get_ability_sprite_from_dir(ability : AbilityData, from_charged : bool = true) -> CompressedTexture2D:
	var ab = charged_ability if from_charged else ability
	
	return ab.sprite_down if direction == Vector2.DOWN else ab.sprite_up if direction == Vector2.UP else ab.sprite_side

#endregion

func input_enabled() -> bool:
	return not transforming and not charging and not spotted and able_to_move

func set_controller(c : PlayerController):
	velocity = Vector2.ZERO
	
	controller = c
	c.player = self
	%Sprite2D.sprite_frames = c.sprite_frames
	%Sprite2D.offset = Vector2(0, (PLAYER_HEIGHT - c.height) / 2)
	c.player_sprite = %Sprite2D
	
	controller.activate()

func on_spotted():
	spotted = true
	velocity = Vector2.ZERO
	
	%CollisionShape.disabled = true
	
	GameMan.camera.change_zoom_smooth(0.25, 0.75)
	
	%Sprite2D.play("spotted_%s" % Utils.get_anim_suffix_based_on_dir(direction))
	if direction.y == 0:
		%Sprite2D.flip_h = true if direction.x < 0 else false
	
	await get_tree().create_timer(1).timeout
	
	GameMan.level_loader.reload_level(true)

func reset():
	end_ability()
	uncharge_ability()
	charging = false
	spotted = false
	
	await get_tree().create_timer(0.1).timeout
	
	%CollisionShape.disabled = false

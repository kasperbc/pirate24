extends CharacterBody2D
class_name Player

const PLAYER_HEIGHT : int = 27

@export var default_controller : PlayerController
@export var transform_duration : float = 2.0

var controller : PlayerController
var move_input : Vector2
var closest_interactable : Interactable

var charged_controller : PackedScene
var transforming : bool = false
var charging : bool = false

var direction : Vector2

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

func get_direction(move_vector : Vector2) -> Vector2:
	if abs(move_vector.x) > abs(move_vector.y):
		return Vector2.LEFT if move_vector.x < 0 else Vector2.RIGHT
	else:
		return Vector2.UP if move_vector.y < 0 else Vector2.DOWN
	

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
		
		if dist > closest_dist or dist > itr.interaction_range:
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

func charge_ability(controller : PackedScene):
	if charged_controller == controller:
		print("This ability is already charged!")
		return
	
	charging = true
	velocity = Vector2.ZERO
	%Sprite2D.play("gain_ability")
	
	await get_tree().create_timer(0.2).timeout
	
	var shaker = Shaker.new()
	%Sprite2D.add_child(shaker)
	shaker.start_shake(%Sprite2D, 0.65)
	
	await get_tree().create_timer(1).timeout
	
	if not charging:
		return
	
	charged_controller = controller
	charging = false
	%Sprite2D.play("default")
	print("Charged ability!")

func uncharge_ability():
	if not has_ability_charged():
		print("No ability charged!")
		return
	
	charged_controller = null

func transform():
	if has_ability():
		push_error("Cannot activate ability another ability is active!")
		return
	
	if not input_enabled():
		return
	
	transforming = true
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(transform_duration).timeout
	
	if not has_ability_charged():
		end_transform()
		return
	
	var new_controller = charged_controller.instantiate()
	add_child(new_controller)
	set_controller(new_controller)
	
	charged_controller = null
	
	end_transform()

func end_transform():
	transforming = false

func end_ability():
	if not has_ability():
		return
	
	controller.queue_free()
	set_controller(default_controller)

func has_ability() -> bool:
	return controller is not BasePlayerController

func has_ability_charged():
	return charged_controller != null

#endregion

func input_enabled() -> bool:
	return not transforming and not charging

func set_controller(c : PlayerController):
	velocity = Vector2.ZERO
	
	controller = c
	c.player = self
	%Sprite2D.sprite_frames = c.sprite_frames
	%Sprite2D.offset = Vector2(0, (PLAYER_HEIGHT - c.height) / 2)
	c.player_sprite = %Sprite2D
	
	controller.activate()

func reset():
	end_ability()
	uncharge_ability()
	charging = false

extends CharacterBody2D
class_name Player

@export var default_controller : PlayerController

var controller : PlayerController
var move_input : Vector2
var closest_interactable : Interactable

var charged_ability : Ability
var charged_ability_controller : PackedScene

func _ready():
	set_controller(default_controller)

func _process(delta):
	move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if controller.able_to_interact:
		interaction_update()
	
	if has_ability_charged() and Input.is_action_just_pressed("use_ability"):
		activate_ability()
	
	controller.process_controller()

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
		
		if dist > closest_dist or dist > itr.range:
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

func charge_ability(ability : Ability, ability_controller : PackedScene):
	if ability == charged_ability:
		print("This ability is already charged!")
		return
	
	charged_ability = ability
	charged_ability_controller = ability_controller
	
	print("Charged ability %s!" % ability.name)

func activate_ability():
	if has_ability():
		push_error("Cannot activate ability another ability is active!")
		return
	
	await Engine.get_main_loop().process_frame
	
	var new_controller = charged_ability_controller.instantiate()
	add_child(new_controller)
	set_controller(new_controller)
	
	charged_ability = null
	charged_ability_controller = null

func end_ability():
	if not has_ability():
		return
	
	controller.queue_free()
	set_controller(default_controller)

func has_ability() -> bool:
	return controller is not BasePlayerController

func has_ability_charged():
	return charged_ability != null and charged_ability_controller != null

#endregion

func set_controller(c : PlayerController):
	velocity = Vector2.ZERO
	
	controller = c
	c.player = self
	%Sprite2D.sprite_frames = c.sprite_frames
	c.player_sprite = %Sprite2D

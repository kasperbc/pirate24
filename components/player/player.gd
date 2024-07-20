extends CharacterBody2D
class_name Player

const BASE_SPEED = 75.0

var closest_interactable : Interactable

var curr_ability : AbilityController

func _process(delta):
	interaction_update()

func _physics_process(delta):
	movement_update()
	move_and_slide()

func movement_update():
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = move_dir * BASE_SPEED

#region Interactables

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

func change_ability(ability : Ability):
	pass

func end_ability():
	pass

#endregion

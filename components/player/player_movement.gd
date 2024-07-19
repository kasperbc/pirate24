extends CharacterBody2D

const SPEED = 75.0


func _physics_process(delta):
	movement_update()
	
	move_and_slide()

func movement_update():
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = move_dir * SPEED

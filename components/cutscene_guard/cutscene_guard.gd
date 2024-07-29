extends CharacterBody2D

@export var play_cutscene : bool = true

func _ready():
	if play_cutscene:
		cutscene()

func cutscene():
	GameMan.player.able_to_move = false
	
	%DialogueText.show_dialogue("text 1")
	await get_tree().create_timer(6).timeout
	%DialogueText.show_dialogue("text 2")
	await get_tree().create_timer(6).timeout
	%DialogueText.show_dialogue("Don't you try to leave...")
	await get_tree().create_timer(2).timeout
	$Sprite2D.animation = "walk_side"
	$Sprite2D.flip_h = false
	velocity = Vector2.RIGHT * 60.0
	await get_tree().create_timer(2.15).timeout
	$Sprite2D.animation = "walk"
	velocity = Vector2.UP * 60.0
	await get_tree().create_timer(3).timeout
	GameMan.player.able_to_move = true

func _physics_process(delta):
	move_and_slide()

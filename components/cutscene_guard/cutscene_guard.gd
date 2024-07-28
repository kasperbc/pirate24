extends CharacterBody2D

func _ready():
	cutscene()

func cutscene():
	%DialogueText.show_dialogue("yooo")
	await get_tree().create_timer(6).timeout
	%DialogueText.show_dialogue("yoooooo")
	await get_tree().create_timer(6).timeout
	%DialogueText.show_dialogue("yooooooooooo")
	await get_tree().create_timer(6).timeout

func _physics_process(delta):
	move_and_slide()

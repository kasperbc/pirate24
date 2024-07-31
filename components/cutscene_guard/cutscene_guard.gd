extends CharacterBody2D

@export var play_cutscene : bool = true

func _ready():
	if play_cutscene and not GameMan.cutscene_seen:
		cutscene()
	else:
		visible = false

func cutscene():
	GameMan.player.able_to_move = false
	
	GameMan.screen_fade.fade_screen_in(1.0)
	
	await get_tree().create_timer(0.5).timeout
	# SoundManager.play_music(AudioLib.get_sound("cutscene"))
	await get_tree().create_timer(1).timeout
	%DialogueText.show_dialogue(
		"... and as always, anything you say can be held against you in the court of interstellar law.",
		2.5)
	SoundManager.play_sound(AudioLib.get_sound("introdialogue1"), "Voice")
	await get_tree().create_timer(5).timeout
	%DialogueText.show_dialogue(
		"Do you understand?",
		0.75)
	SoundManager.play_sound(AudioLib.get_sound("introdialogue2"), "Voice")
	await get_tree().create_timer(2).timeout
	%GubeDialogueText.show_dialogue(
		"But I didn't do anyth-",
		0.75)
	SoundManager.play_sound(AudioLib.get_sound("introdialogue3"), "Voice")
	await get_tree().create_timer(0.75).timeout
	%GubeDialogueText.text = ""
	%DialogueText.show_dialogue(
		"Yeah, yeah, save it for the judge.",
		1.0)
	SoundManager.play_sound(AudioLib.get_sound("introdialogue4"), "Voice")
	await get_tree().create_timer(3).timeout
	%DialogueText.show_dialogue(
		"I can't stay here to guard you, but we have the toughest crew in all of the SCPD.",
		2.25)
	SoundManager.play_sound(AudioLib.get_sound("introdialogue5"), "Voice")
	await get_tree().create_timer(4.0).timeout
	%DialogueText.show_dialogue(
		"So don't even think about leaving.",
		1.0)
	await get_tree().create_timer(3.0).timeout
	%DialogueText.text = ""
	
	
	$Sprite2D.animation = "walk_side"
	$Sprite2D.flip_h = false
	velocity = Vector2.RIGHT * 60.0
	await get_tree().create_timer(2.1).timeout
	$Sprite2D.animation = "walk"
	velocity = Vector2.UP * 60.0
	await get_tree().create_timer(3).timeout
	
	GameMan.player.able_to_move = true
	GameMan.cutscene_seen = true

func _physics_process(delta):
	move_and_slide()

extends Label
class_name DialogueText

@export var dialogue_pos : Node2D
@export_multiline var forget_dialogues : Array[String]
@export var forget_dialogue : Array[Dialogue]

var tweening = false

func show_forget_dialogue():
	show_dialogue(forget_dialogue.pick_random())

func show_dialogue(dialogue : Dialogue):
	if tweening:
		return
	tweening = true
	
	global_position = dialogue_pos.global_position
	
	text = dialogue.dialogue
	modulate = Color(1,1,1,0.8)
	
	if not dialogue.voice_line.is_empty():
		SoundManager.play_sound(AudioLib.get_sound(dialogue.voice_line), "Voice")
	
	var pos_t = get_tree().create_tween().tween_property(self, "global_position", global_position + Vector2.UP * 8, 5.0)
	await get_tree().create_timer(3).timeout
	var col_t = get_tree().create_tween().tween_property(self, "modulate", Color(0,0,0,0), 2.0)
	await get_tree().create_timer(2).timeout
	tweening = false

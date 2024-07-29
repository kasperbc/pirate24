extends Sprite2D

var target_interactable : Interactable = null
var tweening = false

func _ready():
	scale = Vector2(0,1)

func _process(delta):
	var _closest = GameMan.player.closest_interactable
	
	if _closest != target_interactable and not tweening:
		_on_target_change(_closest)

func _on_target_change(new_target : Interactable):
	var old_target = target_interactable
	target_interactable = new_target
	
	if new_target == null:
		change_display(false)
		return
	elif scale.x < 0.1:
		change_display(true)
	
	global_position = target_interactable.global_position + (Vector2.UP * 16)

func change_display(show : bool):
	var val = 1 if show else 0
	
	tweening = true
	
	var t = get_tree().create_tween().set_ease(Tween.EASE_OUT if show else Tween.EASE_IN)
	t.set_trans(Tween.TRANS_ELASTIC if show else Tween.TRANS_SINE)
	t.tween_property(self, "scale", Vector2(val,val), 0.75 if show else 0.25)
	
	await t.finished
	
	tweening = false

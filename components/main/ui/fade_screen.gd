extends ColorRect
class_name ScreenFade

signal fade_completed
signal in_out_fade_halfway

var fading = false

func _ready():
	visible = true

func fade_screen_out_in(duration : float = 1.0, inbetween_fade_duration : float = 1.0):
	fade_screen_out(duration)
	
	await fade_completed
	in_out_fade_halfway.emit()
	await get_tree().create_timer(inbetween_fade_duration).timeout
	
	fade_screen_in(duration)

func fade_screen_out(duration : float = 1.0):
	color = Color(0,0,0,0)
	fade_screen(1, duration)

func fade_screen_in(duration : float = 1.0):
	color = Color(0,0,0,1)
	fade_screen(0, duration, Tween.EASE_OUT)

func fade_screen(val : float, duration : float = 1.0, ease : Tween.EaseType = Tween.EASE_IN):
	var t = get_tree().create_tween().set_ease(ease)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "color", Color(0,0,0,val), duration)
	await t.finished
	
	fade_completed.emit()

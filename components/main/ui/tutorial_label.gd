extends Label

@onready var base_scale = scale

var scream : bool = true
var blink : bool = false

func _ready():
	text = ""

func _process(delta):
	if scream:
		var s_offset = sin(Time.get_unix_time_from_system() * 10) / 50
		scale = base_scale + Vector2.ONE * s_offset
	elif blink:
		visible = roundi(Time.get_unix_time_from_system() * 1.5) % 2 == 0

func activate():
	
	text = "Press [E] near the plant !!!"
	
	await GameMan.player.charged
	
	text = "Press [SPACE] !!!"
	
	await GameMan.player.transformed
	
	%TutorialEnemy.move_speed = 60.0
	scream = false
	
	get_tree().create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	GameMan.player.able_to_move = false
	
	await get_tree().create_timer(5).timeout
	
	GameMan.player.able_to_move = true
	
	blink = true
	
	get_tree().create_tween().tween_property(%GameLogo, "modulate", Color.WHITE, 5.0)
	get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 5.0)
	
	text = "Press [SPACE] to play"
	
	await GameMan.player.untransform_started
	
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).tween_property(%GameLogo, "self_modulate", Color.TRANSPARENT, 0.5)
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).tween_property(self, "self_modulate", Color.TRANSPARENT, 0.5)

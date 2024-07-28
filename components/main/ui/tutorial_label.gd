extends Label

@onready var base_scale = scale

var scream : bool = true


func _ready():
	text = ""

func _process(delta):
	if not scream:
		return
	
	var s_offset = sin(Time.get_unix_time_from_system() * 10) / 50
	
	scale = base_scale + Vector2.ONE * s_offset

func activate():
	
	await GameMan.player.charged
	
	text = "Press [SPACE] !!!"
	
	await GameMan.player.transformed
	
	%TutorialEnemy.move_speed = 60.0
	scream = false
	
	get_tree().create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 10.0)

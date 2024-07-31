extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = -60


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_volume = -60.0 if GameMan.player.has_ability() and not GameMan.dont_play_ability_track else -60.0
	volume_db = lerp(volume_db, target_volume, 0.05)
	

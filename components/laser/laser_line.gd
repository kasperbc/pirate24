extends Line2D

@onready var base_width = width

func _process(delta):
	# width = base_width + sin(Time.get_unix_time_from_system() * 100) / 10
	pass

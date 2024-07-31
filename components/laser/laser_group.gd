extends Node2D
class_name LaserGroup

var lasers : Array[LaserShooter]

@export var offset : float

func _ready():
	for i in get_children():
		if i is LaserShooter:
			lasers.append(i)
	
	var index = 0
	for l in lasers:
		index += 1
		l.blink_offset = offset * index
		l.activate_blink_after_offset()

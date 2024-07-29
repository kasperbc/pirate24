extends Node2D
class_name Interactable

@export var disable_after_interaction : bool = false

var enabled = true

func _ready():
	add_to_group("Interactable")

func interact():
	if not enabled:
		return
	
	_on_interact()
	
	if disable_after_interaction:
		enabled = false

func _on_interact():
	print("Interacted!")

func enable():
	enabled = true

func disable():
	enabled = false

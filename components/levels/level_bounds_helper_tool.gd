@tool
extends Node2D

@export var bounds : LevelBounds

var last_redraw : float = 0

func _process(delta):
	last_redraw += delta
	if last_redraw > 0.5:
		last_redraw = 0
		queue_redraw()

func _draw():
	if bounds == null or not Engine.is_editor_hint():
		return
	
	draw_rect(Rect2(position - (bounds.size / 2), bounds.size), Color.AQUA, false)

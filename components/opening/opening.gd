extends Control

@export var main_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true
	$Spaceship.velocity = Vector2.RIGHT * 15
	
	get_tree().create_tween().tween_property($ColorRect, "modulate", Color.TRANSPARENT, 1.0)
	
	await get_tree().create_timer(2).timeout
	
	get_tree().create_tween().tween_property($YearLabel, "visible_ratio", 1.0, 1.0)
	
	await get_tree().create_timer(2).timeout
	
	get_tree().create_tween().tween_property($LocationLabel, "visible_ratio", 1.0, 1.0)
	
	await get_tree().create_timer(2).timeout
	
	get_tree().create_tween().tween_property($ColorRect, "modulate", Color.WHITE, 0.5)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(main_scene)

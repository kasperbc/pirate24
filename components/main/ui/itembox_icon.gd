extends TextureRect
class_name ItemBoxIcon

@onready var player = GameMan.player

func _process(delta):
	if player == null:
		return
	
	if not player.has_ability_charged() and not player.has_ability():
		set_icon_to_nearest_ability_intr()
		var opacity_offset = sin(Time.get_unix_time_from_system() * 8)
		modulate = Color(1,1,1,0.5 + opacity_offset / 10)
	else:
		modulate = Color.WHITE

func set_icon_to_nearest_ability_intr():
	var ci = player.closest_interactable
	if ci is not AbilityInteractable:
		texture = null
		return
	
	texture = ci.get_icon()

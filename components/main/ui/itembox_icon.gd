extends TextureRect
class_name ItemBoxIcon

func _process(delta):
	
	var player = GameMan.player
	if player == null:
		return
	
	var ci = player.closest_interactable
	if ci is not AbilityInteractable:
		return
	
	texture = ci.icon

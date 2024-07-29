extends StaticBody2D
class_name LevelSegmentDoor

@export var next_segment : LevelSegment

var activated : bool = false

func _ready():
	await Engine.get_main_loop().process_frame
	
	if next_segment != null and GameMan.level_loader.curr_level_seg.segment_id >= next_segment.segment_id:
		%FrontDoorCollider.set_deferred("disabled", false)
		%BackDoorCollider.set_deferred("disabled", true)
		%DoorEnterTrigger.monitoring = false
		%Sprite2D.animation = "closed"
	else:
		%FrontDoorCollider.set_deferred("disabled", true)
		%BackDoorCollider.set_deferred("disabled", false)
		%Sprite2D.animation = "open"

func _on_player_entered(body):
	if body is not Player or activated:
		return
	
	activated = true
	%FrontDoorCollider.set_deferred("disabled", false)
	
	GameMan.level_loader.change_segment(next_segment, true, true)
	
	Utils.create_shaker_and_shake(%Sprite2D, 0.75, 0.5)
	
	%Sprite2D.animation = "closed"
	
	await get_tree().create_timer(1).timeout
	
	%SteamParticleBack.emitting = true
	%SteamParticleFront.emitting = true
	
	Utils.create_shaker_and_shake(%Sprite2D, 1.0, 3.5)
	
	await get_tree().create_timer(3.5).timeout
	
	%SteamParticleBack.emitting = false
	%SteamParticleFront.emitting = false
	
	await get_tree().create_timer(0.5).timeout
	
	Utils.create_shaker_and_shake(%Sprite2D, 0.75, 0.5)
	
	%BackDoorCollider.set_deferred("disabled", true)

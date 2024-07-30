extends Node
class_name LevelLoader

@export var default_level : Level

var curr_level : Node2D
var curr_level_res : Level
var curr_level_seg : LevelSegment
var spawn_pos_override : Vector2

func _ready():
	var level : Level = default_level
	if GameMan.level_override != null:
		level = GameMan.level_override
	
	load_level(level)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		reload_level(true)

func load_level(l : Level, segment : int = 0, reloading : bool = false):
	if curr_level != null:
		unload_current_level()
	
	if GameMan.segement_override != -1:
		segment = GameMan.segement_override
	
	var loaded_level = l.scene.instantiate()
	add_child(loaded_level)
	
	curr_level = loaded_level
	curr_level_res = l
	change_segment(get_level_segment(segment), false, not reloading)
	
	if not reloading:
		spawn_pos_override = Vector2.ZERO
	
	if spawn_pos_override != Vector2.ZERO:
		GameMan.player.global_position = spawn_pos_override
	else:
		GameMan.player.global_position = curr_level_seg.player_start_point.global_position
	
	GameMan.player.reset()
	# GameMan.camera.get_node("Background").color = l.background_color
	
	GameMan.player.spotted = false
	
	GameMan.camera.zoom = Vector2.ONE * 2.5
	GameMan.camera.set_limit_to_curr_segment_bounds()
	
	if not reloading or l.restart_music_on_reload:
		SoundManager.play_music_at_volume(AudioLib.get_sound(l.music), l.music_vol, 1.0)

func reload_level(fade_anim : bool = false):
	if fade_anim:
		GameMan.screen_fade.fade_screen_out_in(0.5, 0.75)
		await GameMan.screen_fade.in_out_fade_halfway
	
	load_level(curr_level_res, curr_level_seg.segment_id, true)

func unload_current_level():
	curr_level.queue_free()
	
	curr_level = null
	curr_level_res = null

func get_level_segment(id) -> LevelSegment:
	for seg in get_tree().get_nodes_in_group("LevelSegment"):
		if seg is not LevelSegment:
			continue
		if seg.level != curr_level:
			continue
		
		if seg.segment_id == id:
			return seg
	return null

func change_segment(to : LevelSegment, pan_camera : bool = false, show_label : bool = false):
	curr_level_seg = to
	
	if pan_camera:
		GameMan.camera.trans_to_limits(GameMan.camera.get_limits_from_bounds(to.bounds), 5.0)
		if show_label:
			await GameMan.camera.transition_complete
			GameMan.segment_label.show_text(curr_level_seg.segment_name)
	elif show_label:
		GameMan.segment_label.show_text(curr_level_seg.segment_name)
		

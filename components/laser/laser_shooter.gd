extends Sprite2D
class_name LaserShooter

var laser_collider
var laser_pos : Vector2
@export_group("Blink")
@export var blink : bool = false
@export var blink_off_duration : float = 1.0
@export var blink_on_duration : float = 1.0
@export var blink_offset : float = 0.0

var spotted_player = false
var active = true

func _ready():
	if blink:
		activate_blink_after_offset()

func activate_blink_after_offset():
	await get_tree().create_timer(blink_offset).timeout
	blink_loop()

func _process(delta):
	cast_laser()
	
	var _active = %PlayerCast.is_colliding() and active
	
	%LaserLine.visible = _active
	if not _active:
		return
	
	laser_collider = %PlayerCast.get_collider()
	laser_pos = %PlayerCast.get_collision_point()
	
	var laser_pos_local = to_local(laser_pos)
	if abs(laser_pos.x) > abs(laser_pos.y):
		laser_pos_local.y = 0
	else:
		laser_pos_local.x = 0
	
	laser_pos = to_global(laser_pos_local)
	
	%LaserLine.points[1] = %LaserLine.to_local(laser_pos)
	
	var spottable = not GameMan.player.has_ability() and not GameMan.player.transforming_end
	
	if laser_collider is Player and spottable and not GameMan.player.spotted and not spotted_player:
		spotted_player = true
		GameMan.player.on_spotted()
		SoundManager.play_sound(AudioLib.get_sound("thud"))
		SoundManager.play_sound(AudioLib.get_sound("alarm"))

func cast_laser():
	%PlayerCast.target_position = position + (Vector2.RIGHT * 10000)
	%PlayerCast.force_raycast_update()

func blink_loop():
	enable()
	await get_tree().create_timer(blink_on_duration).timeout
	
	if GameMan.player.spotted:
		return
	disable()
	await get_tree().create_timer(blink_off_duration).timeout
	
	if GameMan.player.spotted:
		return
	blink_loop()

func disable():
	change_active(false)

func enable():
	change_active(true)

func change_active(val : bool):
	active = val
	%ToggleSound.play()

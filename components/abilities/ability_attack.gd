extends Area2D
class_name AbilityAttack

@export_group("Timing")
@export var attack_delay : float = 0.0
@export var animation_delay : float = 0.0
@export var fadeout_delay : float = 1.0

var dir : Vector2

func _ready():
	start_attack()
	play_attack_anim()

func start_attack():
	for i in 2:
		await get_tree().physics_frame
	
	await get_tree().create_timer(attack_delay).timeout
	attack_guards()
	
	await get_tree().create_timer(fadeout_delay).timeout
	
	_on_fadeout()
	
	var fadeout_tween : Tween = get_tree().create_tween()
	fadeout_tween.tween_property(self, "modulate", Color(1,1,1,0), 1.0)
	await fadeout_tween.finished
	queue_free()

func play_attack_anim():
	await get_tree().create_timer(animation_delay).timeout
	
	var anim_suffix = Utils.get_anim_suffix_based_on_dir(dir)
	%Sprite2D.flip_h = true if anim_suffix == "side" and dir.x < 0 else false
	
	%Sprite2D.play("attack_%s" % anim_suffix)

func attack_guards():
	var nodes = get_overlapping_bodies()
	
	for n in nodes:
		if n is EnemyBehvaiour:
			_attack(n)

func _attack(target : EnemyBehvaiour):
	pass

func _on_fadeout():
	pass

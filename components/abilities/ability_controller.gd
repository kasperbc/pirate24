extends PlayerController
class_name AbilityController

@export var ability : Ability
@export var ability_end_delay : float = 1.0
@export_group("Attack")
@export var attack : PackedScene
@export var attack_spawn_pos_offset : float = 0.0
@export var shake_sprite_on_attack : bool = true

var ability_active = false
var dir : Vector2

func _on_activate():
	super()
	dir = player.direction

func _process_io():
	if not ability_active and is_use_just_pressed():
		activate_ability()

func _process_animation():
	anim_state = "default" if ability_active else "ability"
	
	anim_suffix = Utils.get_anim_suffix_based_on_dir(dir)
	player_sprite.flip_h = true if anim_suffix == "side" and dir.x < 0 else false

func activate_ability():
	ability_active = true
	await _on_ability_activate()
	
	if attack != null:
		create_attack()
	
	await get_tree().create_timer(ability_end_delay).timeout
	
	if ability.single_use:
		GameMan.player.end_ability()
	else:
		ability_active = false

func _on_ability_activate():
	print("Ability activated!")

func create_attack():
	var created_attack : AbilityAttack = attack.instantiate()
	GameMan.level_loader.curr_level.add_child(created_attack)
	
	created_attack.dir = dir
	created_attack.global_position = player.to_global(player.direction * attack_spawn_pos_offset)

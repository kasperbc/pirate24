extends Resource
class_name AbilityData

enum AbilityType {
	DEFAULT = 0,
	PLANT = 1,
	WATER_DISPENSER = 2,
	COFFEE_MACHINE = 3,
	MAGNET = 4,
	TOASTER = 5,
	BOX = 6
}

@export var type : AbilityType
@export var height : float = 0.0
@export var sprite_down : CompressedTexture2D = null
@export var sprite_side : CompressedTexture2D = null
@export var sprite_up : CompressedTexture2D = null
@export_multiline var enemy_dialogues : Array[String]
@export var dialogues : Array[Dialogue]

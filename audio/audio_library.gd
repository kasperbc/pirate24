extends Node

@export var sounds : Array[AudioStream]
@export var default_sound : AudioStream

func get_sound(name : String) -> AudioStream:
	for sound in sounds:
		var sound_name = resource_path_to_name(sound.resource_path)
		
		if sound_name == name:
			return sound
	
	push_error("%s not found in audio library!" % name)
	return default_sound

func resource_path_to_name(path : String) -> String:
	var sound_name_split = path.split("/")
	return sound_name_split[sound_name_split.size() - 1].split(".")[0]

func array_contains_sound(array : PackedStringArray, sound : String) -> bool:
	for s in array:
		if resource_path_to_name(s) == sound:
			return true
	
	return false

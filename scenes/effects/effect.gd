extends Node2D
class_name Effect
@export var SOUND_EFFECT : AudioStreamMP3
func init():
	pass
func play_sound(duration: float = 40):
	if SOUND_EFFECT:
		var sound : SoundSpawner = load("res://scenes/SoundSpawner.tscn").instantiate()
		sound.global_position = get_parent().global_position
		sound.stream = SOUND_EFFECT
		sound.SOUND_DURATION = duration
		sound.TARGET = get_parent()
		sound.max_distance = 4000
		get_tree().get_root().add_child(sound)
		sound.play_sound()
	
func _ready() -> void:
	print("Effect")
	play_sound()
func _on_timer_timeout():
	queue_free()

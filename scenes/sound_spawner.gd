extends AudioStreamPlayer2D
class_name SoundSpawner
@export var SOUND_DURATION : float = 0
var TARGET : RigidBody2D
@export var timer : Timer

func _ready():
	if SOUND_DURATION == 0 and stream:
		SOUND_DURATION = stream.get_length()
	timer.wait_time = SOUND_DURATION

func play_sound():
	print(stream.get_length(),' ',SOUND_DURATION,' ')
	if SOUND_DURATION:
		timer.start()
		play()



func _process(delta: float) -> void:
	if TARGET:
		global_position = TARGET.global_position 
#Sound Ended
func _on_timer_timeout() -> void:
	queue_free() 

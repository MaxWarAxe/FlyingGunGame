extends GPUParticles2D
class_name Particle
var velocity : Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	position += velocity*_delta

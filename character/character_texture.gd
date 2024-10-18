extends AnimatedSprite2D
class_name  CharacterTexture
# Called when the node enters the scene tree for the first time.
func animate(_velocity: Vector2) -> void:
	verify_direction(_velocity.x)
	if not _velocity:
		play("idle")
		return
	if _velocity.y:
		if _velocity.y > 0:
			play("fall")
		if _velocity.y < 0:
			play("jump")
		return
	if _velocity.x:
		play("run")
		return
func verify_direction(_direction: float) -> void:
		if _direction > 0:
			flip_h = false
		if _direction < 0:
			flip_h = true

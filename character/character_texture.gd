extends AnimatedSprite2D
class_name  CharacterTexture
# Called when the node enters the scene tree for the first time.
func animate(_velocity: Vector2) -> void:
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

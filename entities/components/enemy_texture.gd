extends AnimatedSprite2D

class_name  EnemyTexture

@export_category("Objects")
@export var _enemy: BaseEnemy

var _on_action: bool = false
# Called when the node enters the scene tree for the first time.
func animate(velocity: Vector2) -> void:
	if _on_action:
		return
	if velocity.y:
		
		if velocity.y > 0:
			play("fall")
		if velocity.y < 0:
			play("jump")
		return
	if velocity.x:
		play("run")
		return
	play("idle")
	
func action_animate(action: String) -> void:
	_enemy.set_physics_process(false)
	_on_action = true
	play(action)

func _on_animation_finished() -> void:
	_on_action = false
	_enemy.set_physics_process(true)

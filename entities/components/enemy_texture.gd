extends AnimatedSprite2D

class_name  EnemyTexture

@export_category("Variables")
@export var _last_attack_frame:int

@export_category("Objects")
@export var _enemy: BaseEnemy
@export var _attack_area_collision: CollisionShape2D


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
	if animation == "dead_hit":
		_enemy.queue_free()
		return
	if animation == "attack_anticipation":
		action_animate("attack")
		return
	_on_action = false
	_enemy.set_physics_process(true)


func _on_frame_changed() -> void:
	if animation == "attack":
		if frame >= 0:
			_attack_area_collision.disabled = false
		if frame == _last_attack_frame:
			_attack_area_collision.disabled = true

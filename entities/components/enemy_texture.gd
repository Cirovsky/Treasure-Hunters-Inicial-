extends AnimatedSprite2D

class_name  EnemyTexture

@export_category("Variables")
@export var _dead_collision: Vector2
@export var _dead_loop: int = 3
@export var _last_attack_frame:int
@export var _initial_run_frame:int
@export var _last_run_frame:int
@export var _run_effect_offset:Vector2
@export var _attack_effect_offset: Vector2

@export_category("Objects")
@export var _enemy: BaseEnemy
@export var _attack_area_collision: CollisionShape2D
@export var _enemy_collision: CollisionShape2D


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

func _on_frame_changed() -> void:
	var is_flipped:bool = flip_h
	if _enemy._pink_star_enemy:
		is_flipped = not is_flipped
	if animation == "run":
		if frame == _initial_run_frame or frame == _last_run_frame:
			global.spam_effect(
				"res://visual_effects/dust_particles/run/run_effect.tscn",
				_run_effect_offset,
				global_position,
				is_flipped
			)
	if animation == "attack":
		_last_attack_frame = sprite_frames.get_frame_count(animation) -1
		if frame == 0:
			global.spam_effect(
				"res://visual_effects/pink_star_attack/pink_star_attack_effect.tscn",
				_attack_effect_offset,
				global_position,
				is_flipped
			)
		if frame >= 0:
			_attack_area_collision.disabled = false
		if frame == _last_attack_frame:
			_attack_area_collision.disabled = true

func _on_animation_finished() -> void:
	if animation == "dead_hit":
		_enemy_collision.position = _dead_collision
	if animation == "dead_ground":
		print("dead_loop: ",_dead_loop)
		if _dead_loop > 0:
			play("dead_ground")
			_dead_loop -= 1
		else:
			_enemy.queue_free()
	if animation == "attack_anticipation":
		action_animate("attack")
		return
	_on_action = false
	_enemy.set_physics_process(true)

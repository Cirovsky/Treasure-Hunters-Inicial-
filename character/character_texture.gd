extends AnimatedSprite2D
class_name  CharacterTexture

@export_category("Objects")
@export var _character:BaseCharacter
@export var _attack_area_collision: CollisionShape2D
var _suffix: String = ""
var _is_on_action:= false
# Called when the node enters the scene tree for the first time.
func animate(_velocity: Vector2) -> void:
	verify_direction(_velocity.x)
	if _velocity.y != 0:
		_attack_area_collision.position.y = 24
	else:
		_attack_area_collision.position.y = 0
	if _is_on_action:
		return
	if not _velocity:
		play("idle" + _suffix)
		return
	if _velocity.y:
		if _velocity.y > 0:
			play("fall"  + _suffix)
		if _velocity.y < 0:
			play("jump"  + _suffix)
		return
	if _velocity.x:
		play("run"  + _suffix)
		return
		
func verify_direction(_direction: float) -> void:
	if _direction > 0:
		flip_h = false
		_attack_area_collision.position.x = 24
	if _direction < 0:
		flip_h = true
		_attack_area_collision.position.x = -24
		
func action_animation(_action_name: String) -> void:
		_is_on_action = true
		if _action_name == "throw_sword":
			play(_action_name)
			return
		play(_action_name + _suffix)
		return

func _on_animation_finished() -> void:
	_is_on_action = false
	_character.set_physics_process(true)
		
func is_with_sword(sword:bool) -> void:
	if sword:
		_suffix = "_with_sword"
	else:
		_suffix = ""


func _on_frame_changed() -> void:
	var _current_animation: StringName = animation
	if _current_animation.begins_with("air_attack")  or _current_animation.begins_with("attack"):
		if frame >= 0:
				_attack_area_collision.disabled = false
		if frame == 2:
				_attack_area_collision.disabled = true
	if animation == "throw_sword":
		if frame == 2:
			_character.throw_sword(flip_h)
	if animation == "run" or animation == "run_with_sword":
		if frame == 1 or frame == 4:
			global.spam_effect(
				"res://visual_effects/dust_particles/run/run_effect.tscn",
				Vector2(0, 2),
				global_position,
				flip_h
			)

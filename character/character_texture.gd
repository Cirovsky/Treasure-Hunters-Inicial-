extends AnimatedSprite2D
class_name  CharacterTexture

@export_category("Objects")
@export var _character:BaseCharacter
var _suffix: String = ""
var _is_on_action:= false
# Called when the node enters the scene tree for the first time.
func animate(_velocity: Vector2) -> void:
	verify_direction(_velocity.x)
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
	if _direction < 0:
		flip_h = true
		
func action_animation(_action_name: String) -> void:
		_is_on_action = true
		play(_action_name + _suffix)

func _on_animation_finished() -> void:
	_is_on_action = false
	_character.set_physics_process(true)
		
func is_with_sword(sword:bool) -> void:
	if sword:
		_suffix = "_with_sword"
	else:
		_suffix = ""


func _on_frame_changed() -> void:
	if animation == "run" or animation == "run_with_sword":
		if frame == 1 or frame == 4:
			global.spam_effect(
				"res://visual_effects/dust_particles/run/run_effect.tscn",
				Vector2(0, 2),
				global_position,
				flip_h
			)

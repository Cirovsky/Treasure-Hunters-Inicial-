extends CharacterBody2D
class_name BaseCharacter

const _THROWABLE_SWORD: PackedScene = preload("res://throwables/character_sword/character_sword.tscn")
var _extra_jump:int
var _on_floor: = true
var _has_sword: = false
var _attack_index: int = 1
var _air_attack_count: int = 1
var _health: int = 15
@onready var remote_transform:= $Remote as RemoteTransform2D
@onready var _character_texture: = $Texture as CharacterTexture
@onready var _attack_combo: = $AttackCombo as Timer
@export_category("Variables")
@export var _speed = 150.0
@export var _boost := 2
@export var _jump_velocity:= -300

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	_vertical_moviment(_delta)
	_horizontal_moviment()
	_attack_handler()
	move_and_slide()
	_character_texture.animate(velocity)

func _vertical_moviment(_delta:float) -> void:
	if is_on_floor():
		if _on_floor == false:
			#configurar efeito da queda
			_air_attack_count = 2
			global.spam_effect(
				"res://visual_effects/dust_particles/fall/fall_effect.tscn", 
				Vector2(0, 2),
				global_position,
				false
				)
			_character_texture.action_animation("land")
			set_physics_process(false)
			_on_floor = true
		_extra_jump = 1
	# Add the gravity.
	if not is_on_floor():
		if _on_floor:
			_attack_index = 1
		_on_floor = false
		velocity += get_gravity() * _delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and _extra_jump >= 0 and is_on_floor():
		global.spam_effect(
			"res://visual_effects/dust_particles/jump/jump_effect.tscn",
			Vector2(0, 2),
			global_position,
			_character_texture.flip_h
		)
		
		if Input.is_action_pressed("boost"):
				velocity.y = _jump_velocity * 1.1
		else:
			velocity.y = _jump_velocity
		_extra_jump -= 1
	elif Input.is_action_just_pressed("jump") and _extra_jump >= 0:
		if Input.is_action_pressed("boost"):
				velocity.y = _jump_velocity * 1.1
		else:
			velocity.y = _jump_velocity
		_extra_jump -= 2
			
func _horizontal_moviment() -> void:
	var _direction = Input.get_axis("move_left", "move_right")
	if _direction:
		if Input.is_action_pressed("boost"):
			velocity.x = _direction * _speed * _boost
		else:
			velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		
	
func _attack_handler() -> void:
	if not _has_sword:
		return
	if Input.is_action_just_pressed("throw"):
		_character_texture.action_animation("throw_sword")
		update_sword_state(false)
		set_physics_process(false)
		return
	if Input.is_action_just_pressed("attack"):
		if not _on_floor and _air_attack_count > 0:
			_attack_animation_handler("air_attack_",2, true)
		elif _on_floor:
			_attack_animation_handler("attack_",3)
			
func _attack_animation_handler(prefix, index_limit: int, on_air: bool = false) -> void:
	
	global.spam_effect(
			#"res://visual_effects/sword/attack_1/attack_1_effect.tscn"
				"res://visual_effects/sword/" + prefix + str(_attack_index) +"/" + prefix + str(_attack_index) + "_effect.tscn",
				Vector2(24,0),
				global_position,
				_character_texture.flip_h
		)
	_character_texture.action_animation(prefix + str(_attack_index))
	_attack_index += 1
	if on_air:
		_air_attack_count -= 1
	if _attack_index > index_limit:
		_attack_index = 1
	set_physics_process(false)
	_attack_combo.start()	
	return

func throw_sword(is_flipped:bool) -> void:
	var sword: CharacterSword = _THROWABLE_SWORD.instantiate()
	get_tree().root.call_deferred("add_child", sword)
	sword.global_position = global_position
	if is_flipped:
		sword._direction = Vector2(-1, 0)
		return
	sword._direction = Vector2(1, 0)
	return
		
func update_sword_state(state:bool) -> void:
	_has_sword = state
	_character_texture.is_with_sword(state)
	return

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path


func _on_attack_combo_timeout() -> void:
	_attack_index = 1
	
func update_health(value:int, is_damage:float = true) -> void:
	if is_damage:
		_health -= value
	else:
		_health += value
	print(_health)

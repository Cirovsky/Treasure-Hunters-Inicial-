extends CharacterBody2D

class_name BaseEnemy

const SPEED = 120.0
const JUMP_VELOCITY = -400.0
var _on_floor: bool = false
var _direction: Vector2 = Vector2.ZERO

enum _enemy_types {
	STATIC = 0, 
	CHASE = 1, 
	WANDER =2
	}
@export_category("Variables")
@export var _enemy_type: _enemy_types

@export_category("Objects")
@export var _enemy_texture: EnemyTexture
@export var _floor_detection: RayCast2D
@export var _pink_star_enemy:bool = false

func _ready() -> void:
	_direction = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	_udpdate_direction()

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	_vertical_movement(delta)
	match _enemy_type:
		_enemy_types.STATIC:
			print("estático")
		_enemy_types.CHASE:
			print("perseguidor")
		_enemy_types.WANDER:
			wandering()
	move_and_slide()
	_enemy_texture.animate(velocity)
	
func _vertical_movement(delta:float) -> void:
	if is_on_floor():
		if _on_floor == false:
			_enemy_texture.action_animate("land")
		_on_floor = true
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func wandering()-> void:
	if _floor_detection.is_colliding():
		if _floor_detection.get_collider() is TileMapLayer:
			velocity.x = _direction.x * SPEED
			return
	_udpdate_direction()
	velocity.x=0
func _udpdate_direction()-> void:
	_direction.x = -_direction.x
	if _pink_star_enemy:
		if _direction.x > 0:
			_enemy_texture.flip_h = true
		if _direction.x < 0:
			_enemy_texture.flip_h = false
	if _direction.x > 0:
		_floor_detection.position.x = 12
	if _direction.x < 0:
		_floor_detection.position.x = -12
	
	

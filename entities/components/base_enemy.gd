extends CharacterBody2D

class_name BaseEnemy

const JUMP_VELOCITY = -400.0
var _on_floor: bool = false
var _direction: Vector2 = Vector2.ZERO
var _player_in_range: BaseCharacter = null
var _is_alive:bool = true
var _on_knockback:bool = false

enum _enemy_types {
	STATIC = 0, 
	CHASE = 1, 
	WANDER =2
	}
@export_category("Variables")
@export var _enemy_type: _enemy_types
@export var _health:int = 10
@export var _move_speed:float = 128
@export var _knockback_speed:float = 256
@export var _hit_knockback_timer:float = 0.4
@export var _dead_knockback_timer:float = 0.4

@export_category("Objects")
@export var _enemy_texture: EnemyTexture
@export var _floor_detection: RayCast2D
@export var _pink_star_enemy:bool = false
@export var _knockback_timer:Timer

func _ready() -> void:
	_direction = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	_udpdate_direction()

func _process(delta: float) -> void:
	if _on_knockback:
		move_and_slide()
		
func _physics_process(delta: float) -> void:
	_vertical_movement(delta)
	if _is_alive == false:
		move_and_slide()
		return
	if is_instance_valid(_player_in_range) and is_on_floor():
		_attacking()
		return
	match _enemy_type:
		_enemy_types.STATIC:
			print("estático")
		_enemy_types.CHASE:
			print("perseguidor")
		_enemy_types.WANDER:
			_wandering()
	move_and_slide()
	_enemy_texture.animate(velocity)
	
func _vertical_movement(delta:float) -> void:
	if is_on_floor():
		if _is_alive == false:
			velocity.x = 0
			_enemy_texture.action_animate("dead_ground")
		if _on_floor == false:
			_enemy_texture.action_animate("land")
		_on_floor = true
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func _wandering()-> void:
	if _floor_detection.is_colliding() and is_on_floor():
		if _floor_detection.get_collider() is TileMapLayer:
			velocity.x = _direction.x * _move_speed
			return
	_udpdate_direction()
	#velocity.x=0
	
func _udpdate_direction()-> void:
	if is_on_floor():
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
		
func update_health(value:int, entity: BaseCharacter, is_damage:float = true) -> void:
	if _is_alive == false:
		return
	if is_damage:
		_health -= value
		_enemy_texture.action_animate("hit")
		_knockback(entity)
		if _health <= 0:
			_enemy_texture.play("dead_hit")
			_is_alive = false
			_knockback_timer.start(_dead_knockback_timer)
		else:
			_knockback_timer.start(_hit_knockback_timer)
	else:
		_health += value

func _knockback(entity: BaseCharacter)-> void:
	var _x:int = -1 if global_position.x < entity.global_position.x else 1
	#var _x:float = entity.global_position.x
	velocity.x = _x * _knockback_speed
	velocity.y = -1 * _knockback_speed
	_on_knockback = true
	
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		_player_in_range = body
func _attacking() -> void:
	pass
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		_player_in_range = null
		_wandering()


func _on_knock_back_timer_timeout() -> void:
	_on_knockback = false

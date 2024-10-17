extends CharacterBody2D
class_name BaseCharacter

@onready var _texture:= $Texture as AnimatedSprite2D
@export_category("Variables")
@export var _direction:int
@export var _speed = 150.0
@export var _boost := 2.0
@export var _jump:bool
@export var _jump_velocity:= -400

func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_horizontal_moviment(_delta)
	_vertical_moviment(_delta)
	_set_state()
	move_and_slide()

func _set_state() ->void:
	var state = "idle"
	if Input.is_action_pressed("ui_accept"):
		_jump = true
		state = "jump"
	else:
		_jump = false
		if not _jump and not is_on_floor():
			state = "fall"
		elif _direction !=0:
			state = "run"
	if _texture.name != state:
		_texture.play(state)

func _vertical_moviment(_delta:float) -> void:
	
	if is_on_floor():
		pass
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if Input.is_key_pressed(KEY_A):
				velocity.y = _jump_velocity * 1.2
				velocity.x = _direction * _speed * _boost
		else:
			velocity.y = _jump_velocity
func _horizontal_moviment(_delta:float) -> void:
	_direction = Input.get_axis("ui_left", "ui_right")
	if _direction:
		_texture.scale.x = _direction
		if Input.is_key_pressed(KEY_A) and is_on_floor():
			velocity.x = _direction * _speed * _boost
		else:
			velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

extends CharacterBody2D
class_name BaseCharacter

@onready var _texture:= $Texture as AnimatedSprite2D
@export_category("Variables")
var _direction:int
@export var _speed = 150.0
@export var _boost := 2.0
var _jump:bool
@export var _jump_velocity:= -400
var _extra_jump:int

func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_horizontal_moviment(_delta)
	_vertical_moviment(_delta)
	_set_state()
	move_and_slide()

func _set_state() ->void:
	var state = "idle"
	if Input.is_action_pressed("jump") and !is_on_floor():
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
		_extra_jump = 1
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and _extra_jump >= 0:
		if Input.is_action_pressed("boost"):
				velocity.y = _jump_velocity * 1.1
				velocity.x = _direction * _speed * _boost
		else:
			velocity.y = _jump_velocity
		_extra_jump -= 1
			
func _horizontal_moviment(_delta:float) -> void:
	_direction = Input.get_axis("move_left", "move_right")
	if _direction:
		_texture.scale.x = _direction
		if Input.is_action_pressed("boost") and is_on_floor():
			velocity.x = _direction * _speed * _boost
		else:
			velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

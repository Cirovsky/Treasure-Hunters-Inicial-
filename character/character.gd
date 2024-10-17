extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var _texture:= $Texture as AnimatedSprite2D
var _direction:int
var _jump:bool

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_direction = Input.get_axis("ui_left", "ui_right")
	if _direction:
		_texture.scale.x = _direction
		velocity.x = _direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	_set_state()
	move_and_slide()

func _set_state() ->void:
	var state = "idle"
	if Input.is_key_pressed(KEY_SPACE):
		state = "jump"
	elif _direction !=0:
		state = "run"
	if _texture.name != state:
		_texture.play(state)
	

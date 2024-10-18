extends CharacterBody2D
class_name BaseCharacter

@onready var remote_transform:= $Remote as RemoteTransform2D
@export_category("Variables")
var _direction:int
@export var _speed = 150.0
@export var _boost := 2.0
var _jump:bool
@export var _jump_velocity:= -300
var _extra_jump:int

@export_category("Objects")
@onready var _character_texture:= $Texture as CharacterTexture

func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_vertical_moviment(_delta)
	_horizontal_moviment()
	move_and_slide()
	_character_texture.animate(velocity, _jump, is_on_floor(), _direction)

func _vertical_moviment(_delta:float) -> void:
	if is_on_floor():
		_extra_jump = 1
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and _extra_jump >= 0 and is_on_floor():
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
	_direction = Input.get_axis("move_left", "move_right")
	if _direction:
		_character_texture.scale.x = _direction
		if Input.is_action_pressed("boost"):
			velocity.x = _direction * _speed * _boost
		else:
			velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

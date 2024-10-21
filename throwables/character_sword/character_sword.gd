extends ThrowableComponent

class_name CharacterSword

var _direction: Vector2

@export_category("Variables")
@export var _move_speed: = 128.0

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
		
func _physics_process(delta: float) -> void:
	translate(_direction * delta * _move_speed)

extends Area2D

class_name CollectableComponent



func _on_body_entered(body) -> void:
	if body is BaseCharacter:
		_consume(body)
		queue_free()
		

func _consume(body: BaseCharacter) -> void:
	pass

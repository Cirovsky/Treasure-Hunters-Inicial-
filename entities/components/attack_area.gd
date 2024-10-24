extends Area2D
class_name EnemyAttackArea

@export_category("Variables")
@export var _attack_damage: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		body.update_health(_attack_damage)
		print("causou dano")

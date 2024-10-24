extends Area2D
class_name CharacterAttackArea
@export_category("Variables")
@export var _attack_damage:int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print(body is BaseCharacter)
	if body is BaseEnemy:
		print("causar dano ao inimigo")
		body.update_health(_attack_damage)
		print(body._health)

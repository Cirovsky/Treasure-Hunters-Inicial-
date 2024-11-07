extends BaseEnemy

class_name PinkStar

func _attacking() -> void:
	_enemy_texture.action_animate("attack_anticipation")

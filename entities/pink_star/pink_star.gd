extends BaseEnemy

class_name PinkStar

func _attacking() -> void:
	if not is_instance_valid(_player_in_range):
		return
	if _player_in_range._is_alive:	
		_enemy_texture.action_animate("attack_anticipation")

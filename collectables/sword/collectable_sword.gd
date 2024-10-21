extends CollectableComponent

class_name  CollectableSword

func _consume(body: BaseCharacter) -> void:
	body.update_sword_state(true)

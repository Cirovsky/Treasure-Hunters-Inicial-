extends CollectableComponent

class_name  CollectableSword

func _consume(body: BaseCharacter) -> void:
	body.take_a_sword()

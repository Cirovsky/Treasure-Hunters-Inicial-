extends CollectableComponent

class_name  CollectableSword

func _consume(body: BaseCharacter) -> void:
	body.has_a_sword(true)
	self.queue_free()

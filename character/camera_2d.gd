extends Camera2D

func _ready():
	# Ajusta o zoom da câmera para preencher toda a tela
	var aspect_ratio = (get_viewport().size.x / get_viewport().size.y)/2
	#var aspect_ratio = 800/600
	zoom = Vector2(aspect_ratio, 1)

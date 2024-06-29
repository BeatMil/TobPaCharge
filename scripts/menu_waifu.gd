extends Sprite2D


#########################################
# Built-in
#########################################
func _process(delta: float) -> void:
	if get_local_mouse_position().x > 0:
		flip_h = false
	else:
		flip_h = true

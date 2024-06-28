extends "res://scripts/cool_menu_button.gd"


#########################################
## Public function
#########################################
func disable() -> void:
	animation_player.play("disable")
	_is_disabled = true


func enable() -> void:
	_is_disabled = false
	_focus()


#########################################
## Signals
#########################################
func _on_rich_text_label_mouse_entered() -> void:
	if _is_disabled:
		return
	_is_mouse_in = true


func _on_rich_text_label_mouse_exited() -> void:
	if _is_disabled:
		return
	_is_mouse_in = false

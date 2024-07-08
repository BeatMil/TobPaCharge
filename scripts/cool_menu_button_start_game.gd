extends "res://scripts/cool_menu_button.gd"


#########################################
## Helpers
#########################################
var _last_play_animation: String = ""

#########################################
## Public function
#########################################
func disable() -> void:
	if _last_play_animation != "disable": # prevent disable disable... ┐(￣～￣)┌ 
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


func _on_animation_player_current_animation_changed(name: String) -> void:
	_last_play_animation = name

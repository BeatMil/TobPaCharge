extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_open: bool = false


#################################################
# Built-in
#################################################
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_open:
			animation_player.play("off")
		else:
			animation_player.play("on")
		is_open = !is_open
#################################################
# Signals
#################################################
func _on_resume_button_on_press() -> void:
	animation_player.play("off")


func _on_main_menu_button_on_press() -> void:
	animation_player.play("off")
	SceneTransition.change_scene("res://scenes/main_menu.tscn")
	SteamNetwork.leave_lobby()

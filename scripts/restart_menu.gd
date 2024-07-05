extends Control


@export var current_scene: String


func _ready():
	visible = false


@rpc("any_peer", "call_local")
func _restart():
	SceneTransition.change_scene(current_scene)


func open():
	$"AnimationPlayer".play("fade_in")


func _on_rematch_button_on_press() -> void:
	rpc("_restart")


func _on_main_menu_button_on_press() -> void:
	SceneTransition.change_scene("res://scenes/main_menu.tscn")
	SteamNetwork.leave_lobby()

extends Control


@export var current_scene: String


func _ready():
	visible = false


func _on_button_pressed():
	rpc("_restart")


@rpc("any_peer", "call_local")
func _restart():
	SceneTransition.change_scene(current_scene)


func open():
	$"AnimationPlayer".play("fade_in")

extends Control


@export var current_scene: String


func _ready():
	visible = false


func _on_button_pressed():
	SceneTransition.change_scene(current_scene)


func open():
	$"AnimationPlayer".play("fade_in")

extends Control


#############################################################
## Exports
#############################################################
@export var current_scene: String


#############################################################
## Preloads
#############################################################
const GACHA_DISPLAY = preload("res://nodes/helpers/gacha_display.tscn")


#############################################################
## Nodes References
#############################################################
@onready var gacha_pos: Marker2D = $GachaPos


func _ready():
	visible = false


@rpc("any_peer", "call_local")
func _restart():
	SceneTransition.change_scene(current_scene)


func open():
	$"AnimationPlayer".play("fade_in")
	var gacha = GACHA_DISPLAY.instantiate()
	gacha.position = gacha_pos.position
	add_child(gacha)


func _on_rematch_button_on_press() -> void:
	rpc("_restart")


func _on_main_menu_button_on_press() -> void:
	SceneTransition.change_scene("res://scenes/main_menu.tscn")
	SteamNetwork.leave_lobby()

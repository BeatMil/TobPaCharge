class_name CoolMenuButton
extends Node2D
#########################################
## exports
#########################################
@export var text_on_button: String = ""

#########################################
## Signals
#########################################
signal on_press


#########################################
## Nodes Reference
#########################################
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var sfx_player: AnimationPlayer = $SfxPlayer


#########################################
## Helpers
#########################################
var _is_mouse_in: bool = false
var _is_disabled: bool = false

#########################################
## Built-in
#########################################
func _ready() -> void:
	rich_text_label.text = text_on_button
	_unfocus()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1 and _is_mouse_in \
			and not _is_disabled:
			emit_signal("on_press")
			animation_player.play("pressed")


#########################################
## Public function
#########################################
func disable() -> void:
	animation_player.play("disable")
	_is_disabled = true


func enable() -> void:
	animation_player.play("RESET")
	_is_disabled = false


#########################################
## Private function
#########################################
func _focus() -> void:
	animation_player.play("focus")


func _unfocus() -> void:
	animation_player.play_backwards("focus")


#########################################
## Signals
#########################################
func _on_rich_text_label_mouse_entered() -> void:
	if _is_disabled:
		return
	sfx_player.play("mouse_in")
	_focus()
	_is_mouse_in = true


func _on_rich_text_label_mouse_exited() -> void:
	if _is_disabled:
		return
	_unfocus()
	_is_mouse_in = false

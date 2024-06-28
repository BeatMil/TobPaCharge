extends Node2D

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


#########################################
## Built-in
#########################################
func _ready() -> void:
	rich_text_label.text = text_on_button
	_unfocus()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1 and _is_mouse_in:
			emit_signal("on_press")
			animation_player.play("pressed")


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
	sfx_player.play("mouse_in")
	_focus()
	_is_mouse_in = true


func _on_rich_text_label_mouse_exited() -> void:
	_unfocus()
	_is_mouse_in = false

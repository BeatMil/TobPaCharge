extends CoolMenuButton


@onready var icon_player: AnimationPlayer = $Icon/AnimationPlayer


#########################################
## Helpers
#########################################
signal toggle_pressed
var _is_pressed: bool = false


#########################################
## Built-in
#########################################
func _ready() -> void:
	_unfocus()
	icon_player.play("unpressed")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == 1 and _is_mouse_in \
			and not _is_disabled:
			animation_player.play("pressed")
			icon_player.play("pressed")
			if _is_pressed:
				icon_player.play("hover")
			_is_pressed = !_is_pressed
			emit_signal("toggle_pressed", _is_pressed)


#########################################
## Signals
#########################################
func _on_rich_text_label_mouse_entered() -> void:
	if _is_disabled:
		return
	sfx_player.play("mouse_in")
	_focus()
	_is_mouse_in = true
	if not _is_pressed:
		icon_player.play("hover")


func _on_rich_text_label_mouse_exited() -> void:
	if _is_disabled:
		return
	_unfocus()
	_is_mouse_in = false
	if not _is_pressed:
		icon_player.play("unpressed")

extends TextureButton
@onready var block_panel = $BlockPanel


func set_block_touch(_value: bool) -> void:
	block_panel.visible = _value


func _on_toggled(toggled_on):
	if toggled_on:
		set_block_touch(true)

extends TextureButton
@onready var block_panel = $BlockPanel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_block_touch(_value: bool) -> void:
	block_panel.visible = _value


func _on_toggled(toggled_on):
	if toggled_on:
		animation_player.play("button_down")
		set_block_touch(true)

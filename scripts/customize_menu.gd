extends Node2D


#############################################################
## Built-In
#############################################################
func _ready() -> void:
	set_deferred("visible", false)


#############################################################
## Recieve Signal
#############################################################
func _on_texture_button_button_down() -> void:
	set_deferred("visible", false)

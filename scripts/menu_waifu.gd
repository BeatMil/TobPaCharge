extends Sprite2D


#############################################################
## Nodes References
#############################################################
@onready var label_player: AnimationPlayer = $LabelPlayer


#############################################################
## Signals
#############################################################
signal on_press


#########################################
# Built-in
#########################################
func _ready() -> void:
	label_player.play("idle")


func _process(delta: float) -> void:
	if get_local_mouse_position().x > 0:
		flip_h = false
	else:
		flip_h = true


#########################################
# Signals
#########################################
func _on_button_button_down() -> void:
	emit_signal("on_press")

extends Node2D


# configs
var time_control:int = 1
var player_choice: int = ActionEnum.actions.CHARGE
var bot_choice: int = ActionEnum.actions.CHARGE


# signals
signal new_turn


func _ready():
	connect("new_turn", $Bot.new_turn)
	connect("new_turn", $Player.new_turn)
	$TimeControl.wait_time = time_control
	$TimeControl.start()
	emit_signal("new_turn")


func _process(_delta):
	$TimeLeftLabel.text = "%.2f" %$TimeControl.time_left


func _on_time_control_timeout():
	$TimeControl.start()
	emit_signal("new_turn")

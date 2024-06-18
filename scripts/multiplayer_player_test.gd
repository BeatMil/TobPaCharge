extends Node2D


# This should be important
var player_id := 1:
	set(_id):
		player_id = _id
		%MultiplayerSynchronizer.set_multiplayer_authority(_id)
		print_rich("[color=orange][b]Mul_auth set!: %s[/b][/color]"%_id)
		#set_multiplayer_authority(_id)


func _ready():
	if %MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		print_rich("[color=purple][b]THIS IS NOT YOURS[/b][/color]")
		for node in $Buttons.get_children():
			node.set_deferred("disabled", true)
		#set_process(false)
		#set_physics_process(false)
	else:
		print_rich("[color=green][b]Yours nyaa: %s[/b][/color]"%name)


# @rpc("call_local")
func turn_white():
	$AnimationPlayer.play("white")


# @rpc("call_local")
func turn_blue():
	$AnimationPlayer.play("blue")


# @rpc("call_local")
func turn_green():
	$AnimationPlayer.play("green")

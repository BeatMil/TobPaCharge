extends Node2D


# This should be important
var player_id := 1:
	set(_id):
		player_id = _id
		$MultiplayerSynchronizer.set_multiplayer_authority(_id)
		set_multiplayer_authority(_id)


@rpc("call_local")
func turn_white():
	$AnimationPlayer.play("white")


@rpc("call_local")
func turn_blue():
	$AnimationPlayer.play("blue")


@rpc("call_local")
func turn_green():
	$AnimationPlayer.play("green")

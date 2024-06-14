extends Node2D


# This should be important
@export var player_id := 1:
	set(id):
		player_id = id
		$MultiplayerSynchronizer.set_multiplayer_authority(id)


func turn_white():
	$AnimationPlayer.play("white")


func turn_blue():
	$AnimationPlayer.play("blue")


func turn_green():
	$AnimationPlayer.play("green")

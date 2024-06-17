extends Node2D


#################################################
## Nodes
#################################################
@onready var action_label: Label = $ActionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvaslayer: CanvasLayer = $CanvasLayer


#################################################
## Preloads
#################################################
var FIREBALL = preload("res://nodes/fireball.tscn")


#################################################
# properties
#################################################
var charge_count: int = 0
var steam_id: int = 0:
	set(_id):
		steam_id = _id
		if _id != SteamNetwork.steam_id:
			canvaslayer.visible = false


#################################################
# Configs
#################################################
var chosen_action = ActionEnum.actions.CHARGE
var hp = 1


#################################################
## Notifications
#################################################
func _ready():
	print_rich("[color=Deeppink][b]steam_id: %s, actual_steam_id: %s[/b][/color]"%
	[steam_id, SteamNetwork.steam_id])
	get_parent().connect("new_turn", new_turn)
	get_parent().connect("resolve_phase", resolve_phase)
	# print_rich("[color=green][b]Nyaaa > w <[/b][/color]")
	# print_rich("[img]res://media/TobPaCharge_icon.png[/img]")

#################################################
## public functions
#################################################
@rpc("any_peer", "call_local")
func do_the_action(the_action: ActionEnum.actions) -> void:
	chosen_action = the_action
	action_label.text = ActionEnum.actions.keys()[chosen_action]


func random_action():
	# I don't know how this line work but that's fine XD
	## Edited: ohhhh my god that's genius! XD
	# chosen_action = randi() % ActionEnum.actions.size()
	chosen_action = ActionEnum.actions.CHARGE


func resolve_phase():
	# Update action Label
	action_label.text = ActionEnum.actions.keys()[chosen_action]

	# Update animation
	if chosen_action == ActionEnum.actions.FIREBALL:
		animation_player.play("fireball")
		spawn_fireball()
	elif chosen_action == ActionEnum.actions.BLOCK:
		animation_player.play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		animation_player.play("charge")
		charge_count += 1


func spawn_fireball():
	if charge_count:
		charge_count -= 1
		var fireball = FIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		fireball.is_going_right_side = true
		fireball.set_target("p2")
		add_child(fireball)


func new_turn():
	random_action()
	animation_player.play("idle")
	action_label.text = "CHARGE"


#################################################
## Signals
#################################################
func _on_area_2d_area_entered(area):
	if area.is_in_group("fireball"):
		if chosen_action in [ActionEnum.actions.CHARGE, ActionEnum.actions.CHARGE]
			or (chosen_action == ActionEnum.actions.FIREBALL and charge <= 0):
			animation_player.play("hitted")
			hp -= 1


func _on_fire_ball_button_pressed():
	rpc("do_the_action", ActionEnum.actions.FIREBALL)


func _on_block_button_pressed():
	rpc("do_the_action", ActionEnum.actions.BLOCK)


func _on_charge_button_pressed():
	rpc("do_the_action", ActionEnum.actions.CHARGE)



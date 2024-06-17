extends Node2D


#################################################
## Nodes
#################################################
@onready var action_label: Label = $ActionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvaslayer: CanvasLayer = $CanvasLayer
@onready var big_fireball_button: Button = $CanvasLayer/Buttons/BigFireBallButton


#################################################
## Preloads
#################################################
var FIREBALL = preload("res://nodes/fireball.tscn")
var BIGFIREBALL = preload("res://nodes/big_fireball.tscn")


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


func resolve_phase():
	# Update action Label
	action_label.text = ActionEnum.actions.keys()[chosen_action]

	# Update animation
	if chosen_action == ActionEnum.actions.FIREBALL:
		animation_player.play("fireball")
		spawn_fireball("normal")
	elif chosen_action == ActionEnum.actions.BLOCK:
		animation_player.play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		animation_player.play("charge")
		charge_count += 1
	elif chosen_action == ActionEnum.actions.BIGFIREBALL:
		animation_player.play("big_fireball")
		spawn_fireball("BIG")


func spawn_fireball(type: String):
	if charge_count and type == "normal":
		charge_count -= 1
		var fireball = FIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		if name == "Player1":
			fireball.is_going_right_side = true
			fireball.set_target("p2")
		elif name == "Player2":
			fireball.is_going_right_side = false
			fireball.set_target("p1")
		add_child(fireball)
	elif charge_count >= 3 and type == "BIG":
		charge_count -= 3
		var fireball = BIGFIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		if name == "Player1":
			fireball.is_going_right_side = true
			fireball.set_target("p2")
		elif name == "Player2":
			fireball.is_going_right_side = false
			fireball.set_target("p1")
		add_child(fireball)


func new_turn():
	chosen_action = ActionEnum.actions.CHARGE
	action_label.text = "CHARGE"
	animation_player.play("idle")
	if charge_count >= 3:
		big_fireball_button.set_deferred("visible", true)
	else:
		big_fireball_button.set_deferred("visible", false)


#################################################
## Signals
#################################################
func _on_area_2d_area_entered(area):
	if area.is_in_group("fireball"):
		if chosen_action in [ActionEnum.actions.CHARGE, ActionEnum.actions.FIREBALL]:
			animation_player.play("hitted")
			hp -= 1
	elif area.is_in_group("big_fireball"):
		print_rich("[color=Deeppink][b]GOT HIT BY BIG_FIREBALL[/b][/color]")
		if chosen_action not in [ActionEnum.actions.BIGFIREBALL]:
			animation_player.play("hitted")
			hp -= 1

func _on_fire_ball_button_pressed():
	rpc("do_the_action", ActionEnum.actions.FIREBALL)


func _on_block_button_pressed():
	rpc("do_the_action", ActionEnum.actions.BLOCK)


func _on_charge_button_pressed():
	rpc("do_the_action", ActionEnum.actions.CHARGE)


func _on_big_fire_ball_button_pressed():
	rpc("do_the_action", ActionEnum.actions.BIGFIREBALL)

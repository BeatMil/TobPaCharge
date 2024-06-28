extends Node2D


#################################################
## Nodes
#################################################
@onready var avatar_texture_rect:TextureRect = %AvatarTexture
@onready var action_label: Label = $ActionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvaslayer: CanvasLayer = $CanvasLayer
@onready var buttons: Control = $CanvasLayer/Buttons
@onready var big_fireball_button: TextureButton = $CanvasLayer/Buttons/BigFireBallButton

@onready var charge_meter = %ChargeMeter
@onready var backwind_marker_2d = $backwindMarker2D
@onready var fireball_button: TextureButton = $CanvasLayer/Buttons/FireballButton
@onready var block_button: TextureButton = $CanvasLayer/Buttons/BlockButton


#################################################
## Preloads
#################################################
const FIREBALL = preload("res://nodes/fireball.tscn")
const BIGFIREBALL = preload("res://nodes/big_fireball.tscn")
const BACKWIND_VFX_P_1 = preload("res://nodes/particles_effects/backwind_vfx_p1.tscn")
const BACKWIND_VFX_P_2 = preload("res://nodes/particles_effects/backwind_vfx_p2.tscn")


#################################################
# properties
#################################################
var charge_count: int = 0
var steam_id: int = 0:
	set(_id):
		steam_id = _id
		if _id != SteamNetwork.steam_id:
			canvaslayer.visible = false
			action_label.visible = false
var is_action_choosed:bool = false


#################################################
# Configs
#################################################
var chosen_action = ActionEnum.actions.CHARGE
var hp = 1


########################################
# signals
########################################
signal action_choosed


#################################################
## Notifications
#################################################
func _ready():
	print_rich("[color=Deeppink][b]steam_id: %s, actual_steam_id: %s[/b][/color]"%
	[steam_id, SteamNetwork.steam_id])
	Steam.connect("avatar_loaded", _on_avatar_loaded)
	get_parent().connect("new_turn", new_turn)
	get_parent().connect("resolve_phase", resolve_phase)
	get_parent().get_node("TimeControl").connect("timeout", _on_time_control_timeout)
	# print_rich("[color=green][b]Nyaaa > w <[/b][/color]")
	# print_rich("[img]res://media/TobPaCharge_icon.png[/img]")

#################################################
## public functions
#################################################
@rpc("any_peer", "call_local")
func do_the_action(the_action: ActionEnum.actions) -> void:
	chosen_action = the_action
	action_label.text = ActionEnum.actions.keys()[chosen_action]
	is_action_choosed = true
	emit_signal("action_choosed")


func set_disable_all_buttons(_value: bool) -> void:
	for node in buttons.get_children():
		node.set_deferred("disabled", _value)


func set_block_touch_all_buttons(_value: bool) -> void:
	for node in buttons.get_children():
		if node.has_method("set_block_touch"):
			node.set_block_touch(false)


func set_pressed_all_buttons(_value: bool) -> void:
	for node in buttons.get_children():
		node.button_pressed = _value


func spawn_fireball(type: String):
	if charge_count > 0 and type == "normal":
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
		var fireball = BIGFIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		if name == "Player1":
			fireball.is_going_right_side = true
			fireball.set_target("p2")
		elif name == "Player2":
			fireball.is_going_right_side = false
			fireball.set_target("p1")
		_spawn_backwind_vfx()
		add_child(fireball)


func resolve_phase():
	print_rich("[color=Rosybrown ][b]resolve_phase %s[/b][/color]"%name)
	# Update action Label
	action_label.text = ActionEnum.actions.keys()[chosen_action]
	set_disable_all_buttons(true)

	# Update animation
	if chosen_action == ActionEnum.actions.FIREBALL:
		animation_player.play("fireball")
		if charge_count > 0:
			spawn_fireball("normal")
			charge_count -= 1
			charge_meter.discharge()
	elif chosen_action == ActionEnum.actions.BLOCK:
		animation_player.play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		animation_player.play("charge")
		charge_count += 1
		charge_meter.charge()
	elif chosen_action == ActionEnum.actions.BIGFIREBALL:
		animation_player.play("big_fireball")
		if charge_count >= 3:
			spawn_fireball("BIG")
			charge_count -= 3
			charge_meter.discharge_big_fireball()


func new_turn():
	chosen_action = ActionEnum.actions.CHARGE
	action_label.text = "CHARGE"
	animation_player.play("idle")
	set_disable_all_buttons(false)
	set_block_touch_all_buttons(false)
	set_pressed_all_buttons(false)
	is_action_choosed = false
	if charge_count >= 3:
		big_fireball_button.set_deferred("visible", true)
	else:
		big_fireball_button.set_deferred("visible", false)


#################################################
## private functions
#################################################
func _spawn_backwind_vfx() -> void:
	if name == "Player1":
		var vfx = BACKWIND_VFX_P_1.instantiate()
		vfx.position = backwind_marker_2d.position
		add_child(vfx)
	elif name == "Player2":
		var vfx = BACKWIND_VFX_P_2.instantiate()
		vfx.position = backwind_marker_2d.position
		add_child(vfx)


#################################################
## Signals
#################################################
func _on_area_2d_area_entered(area):
	if area.is_in_group("fireball"):
		if chosen_action not in [ActionEnum.actions.BLOCK]:
			print_rich("[color=Silver ][b]Hit by fireball action: %s[/b][/color]"%
			chosen_action)
			animation_player.play("hitted")
			hp -= 1
	elif area.is_in_group("big_fireball"):
		print_rich("[color=Deeppink][b]GOT HIT BY BIG_FIREBALL[/b][/color]")
		if chosen_action not in [ActionEnum.actions.BIGFIREBALL]:
			animation_player.play("hitted")
			hp -= 1


func _on_time_control_timeout() -> void:
	if SteamNetwork.steam_id == steam_id:
		if not is_action_choosed:
			_on_charge_button_button_down()
			print_rich("[color=Lightcoral ][b]DEFAULT CHARGE[/b][/color]")


func _on_fireball_button_toggled(toggled_on):
	if toggled_on:
		rpc("do_the_action", ActionEnum.actions.FIREBALL)
		set_disable_all_buttons(true)
		fireball_button.set_deferred("disabled", false)
		fireball_button.set_block_touch(true)


func _on_block_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		rpc("do_the_action", ActionEnum.actions.BLOCK)
		set_disable_all_buttons(true)
		block_button.set_deferred("disabled", false)
		block_button.set_block_touch(true)


func _on_charge_button_button_down():
	rpc("do_the_action", ActionEnum.actions.CHARGE)
	set_disable_all_buttons(true)


func _on_big_fire_ball_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		rpc("do_the_action", ActionEnum.actions.BIGFIREBALL)
		set_disable_all_buttons(true)
		big_fireball_button.set_deferred("disabled", false)
		big_fireball_button.set_block_touch(true)


#################################################
## Callbacks
#################################################
func _on_avatar_loaded(id: int, avatar_size: int, buffer: PackedByteArray) -> void:
	if id == steam_id:
		# Create the image and texture for loading
		var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size,
				false, Image.FORMAT_RGBA8, buffer)

		var avatar_texture : ImageTexture = ImageTexture.create_from_image(avatar_image)
		# Display it
		avatar_texture_rect.set_texture(avatar_texture)

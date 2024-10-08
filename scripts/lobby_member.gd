extends Control

@export var username_label: RichTextLabel
var steam_id: int = 0
var steam_name: String = "[empty]"
var is_ready: bool = false
@onready var ready_label: RichTextLabel = $ReadyLabel
@onready var cool_menu_ready_button: Node2D = $CoolMenuReadyButton
@onready var skill_player: AnimationPlayer = $SkillIcon/AnimationPlayer


# signal
signal ready_state_change

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size = size
	Steam.connect("avatar_loaded", _on_avatar_loaded)
	if steam_id != Steam.getSteamID():
		cool_menu_ready_button.set_deferred("visible", false)

	ready_label.get_node("AnimationPlayer").play("stand_by")
	cool_menu_ready_button.enable()


# Set this player up
func set_member(_steam_id: int, _steam_name: String) -> void:
	# Set the ID and username
	steam_id = _steam_id
	steam_name = _steam_name

	username_label.set_text(steam_name)

	# Get the avatar and show it
	Steam.getPlayerAvatar(Steam.AVATAR_LARGE, steam_id)


@rpc("any_peer", "call_local")
func toggle_ready(toggled_on) -> void:
	print_rich("[color=orange][b]toggle_ready()✓[/b][/color]")
	if toggled_on:
		$ReadyLabel/AnimationPlayer.play("ready")
		is_ready = true
		# SteamNetwork.rpc("test_show_pic")
	else:
		$ReadyLabel/AnimationPlayer.play("stand_by")
		is_ready = false
	emit_signal("ready_state_change")


@rpc("any_peer", "call_local")
func show_double_fireball() -> void:
	# if steam_id == Steam.getSteamID():
	skill_player.play("double_fireball")


@rpc("any_peer", "call_local")
func show_heart_charge() -> void:
	# if steam_id == Steam.getSteamID():
	skill_player.play("heart_charge")


@rpc("any_peer", "call_local")
func get_current_skill_then_show() -> void:
	pass


#################################################
# CALLBACKS
#################################################
# Avatar is ready for display
func _on_avatar_loaded(id: int, avatar_size: int, buffer: PackedByteArray) -> void:
	if id == steam_id:
		# Create the image and texture for loading
		var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size,
				false, Image.FORMAT_RGBA8, buffer)

		var avatar_texture : ImageTexture = ImageTexture.create_from_image(avatar_image)
		# Display it
		$"AvatarTexture".set_texture(avatar_texture)


func _on_cool_menu_ready_button_toggle_pressed(toggled_on: bool) -> void:
	if rpc("toggle_ready", toggled_on): 
		# if error
		printerr("rpc toggle_ready error!")

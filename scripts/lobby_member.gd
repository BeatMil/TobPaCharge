extends Control

@export var username_label: Label
var steam_id: int = 0
var steam_name: String = "[empty]"


# Called when the node enters the scene tree for the first time.
func _ready():
	Steam.connect("avatar_loaded", _on_avatar_loaded)


# Set this player up
func set_member(_steam_id: int, _steam_name: String) -> void:
	# Set the ID and username
	steam_id = _steam_id
	steam_name = _steam_name

	username_label.set_text(steam_name)

	# Get the avatar and show it
	Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, steam_id)


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

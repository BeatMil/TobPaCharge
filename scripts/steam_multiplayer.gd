extends Node2D

"""
Beat's Note
- Check if steam is running
- Check if user owns the game
- Then you can get userID, userSteamLevel, userAvatar

To get userAvatar: you gotta connect avatar_loaded first
avatar_loaded returns 3 args which is id, avatar_size and buffer
use avatar_size and buffer to create texture then assign it to TextureRect


This is what I learned so far...
"""


var is_on_steam: bool = false
var is_on_steam_deck: bool = false
var is_online: bool = false
var is_owned: bool = false
var steam_id: int = 0
var steam_username: String = "[not set]"



func _ready() -> void:
	Steam.connect("avatar_loaded", _on_avatar_loaded)
	_initialize_steam() # check if steam is running


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks()


func _initialize_steam() -> void:
	if Engine.has_singleton("Steam"):
		OS.set_environment("SteamAppId", str(480))
		OS.set_environment("SteamGameId", str(480))

		var init_response: Dictionary = Steam.steamInit(false)
		print("init_response: " +str(init_response))
		# If the status isn't one, print out the possible error and quit the program
		if init_response['status'] != 1:
			printerr("[STEAM] Failed to initialize: %s Shutting down..." %
			str(init_response['verbal']))
			get_tree().quit()

		# Is the user actually using Steam; if false,
		# the app assumes this is a non-Steam version
		is_on_steam = true

		# Checking if the app is on Steam Deck to modify certain behaviors
		is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()

		# Acquire information about the user
		is_online = Steam.loggedOn()
		steam_id = Steam.getSteamID()
		steam_username = Steam.getPersonaName()

		# Check if account owns the game
		is_owned = Steam.isSubscribed()

		if is_owned == false:
			printerr("[STEAM] User does not own this game")
			# Uncomment this line to close the game if the user does not own the game
			#get_tree().quit()

	else:
		printerr("Engine does not have the Steam Singleton! Please make sure \n
		you add GodotSteam as a GDNative / GDExtension Plug-in, or with a \n
		compiled Godot version including GodotSteam / Steamworks.\n\n
		For more information, visit https://godotsteam.com/")

#################################################
# CALLBACKS
#################################################

# Avatar is ready for display
func _on_avatar_loaded(id: int, avatar_size: int, buffer: PackedByteArray) -> void:
	print("Avatar for user: "+str(id)+", size: "+str(avatar_size))

	# Create the image and texture for loading
	var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size, 
			false, Image.FORMAT_RGBA8, buffer)
		
	var avatar_texture : ImageTexture = ImageTexture.create_from_image(avatar_image)
	# Display it
	$"AvatarTexture".set_texture(avatar_texture)

func _on_button_pressed():
	print("bob")
	if is_online:
		print("bob2")
		$"UsernameLabel".text = Steam.getPersonaName()
		$"UserLevelLabel".text = str(Steam.getPlayerSteamLevel())


func _on_button_2_pressed():
	Steam.getPlayerAvatar(Steam.AVATAR_LARGE, Steam.getSteamID())


func _on_button_3_pressed():
	Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, Steam.getSteamID())


func _on_button_4_pressed():
	Steam.getPlayerAvatar(Steam.AVATAR_SMALL, Steam.getSteamID())

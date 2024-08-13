extends Node


#############################################################
# Configs
#############################################################
const save_path = "user://savegame.dat"


#############################################################
# inventory data
#############################################################
var inventory = {
	"bowtie_blue": false,
	"bowtie_green": false,
	"bowtie_pink": false,
	"bowtie_purple": false,
	"bowtie_red": false,
	"bowtie_yellow": false,
	"skull_blue": false,
	"skull_green": false,
	"skull_pink": true,
	"skull_purple": false,
	"skull_red": false,
	"skull_yellow": false,
	"gura_blue": false,
	"gura_green": false,
	"gura_pink": false,
	"gura_purple": false,
	"gura_red": false,
	"gura_yellow": false,
	"gun_blue": true,
	"gun_green": false,
	"gun_pink": false,
	"gun_purple": false,
	"gun_red": false,
	"gun_yellow": false,
	"kunai_blue": true,
	"kunai_green": false,
	"kunai_pink": false,
	"kunai_purple": false,
	"kunai_red": false,
	"kunai_yellow": false,
	"pouch_blue": true,
	"pouch_green": false,
	"pouch_pink": false,
	"pouch_purple": false,
	"pouch_red": false,
	"pouch_yellow": false,
}


#############################################################
# Public functions
#############################################################
func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(inventory)

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)


func load_game() -> void:
	var file = FileAccess.open(save_path, FileAccess.READ)

	# Retrieve data
	var json = JSON.new()
	var error = json.parse(file.get_line())
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			print(data_received) # Prints array
			inventory.merge(data_received, true)
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_path, " at line ", json.get_error_line())

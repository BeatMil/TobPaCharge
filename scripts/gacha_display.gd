extends Node2D


#############################################################
## Preloads
#############################################################
const BOWTIE_TYPE = preload("res://nodes/cosmetics/bowtie_type.tscn")
const HIPS_TYPE = preload("res://nodes/cosmetics/hips_type.tscn")
const HIT_SPARK_FIREBALL = preload("res://nodes/particles_effects/hit_spark_fireball.tscn")


#############################################################
## Nodes References
#############################################################
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_player: AnimationPlayer = $Label/AnimationPlayer


#############################################################
## Built-In
#############################################################
func _ready() -> void:
	run_gacha()


#############################################################
## Public functions
#############################################################
func run_gacha() -> void:
	var the_thing = _random_gacha()
	var parts = the_thing.split("_")
	var real_type = _determine_cosmetic_type(parts[0])
	if real_type == "bowtie":
		_spawn_bowtie_gacha(parts[0], parts[1])
	elif real_type == "hips":
		_spawn_hips_gacha(parts[0], parts[1])
	animation_player.play("run_gacha")
	label_player.play("pop_in")

	# Get achievement!
	if _count_inventory() >= 36:
		SteamNetwork.activate_first_achivement("COSMETIC_36_GET")
		print("achivement bob")
	elif _count_inventory() >= 10:
		SteamNetwork.activate_first_achivement("COSMETIC_10_GET")
		print("achivement bob10")
	elif _count_inventory() >= 5:
		SteamNetwork.activate_first_achivement("COSMETIC_5_GET")
		print("achivement bob5")


#############################################################
## Private functions
#############################################################
func _random_gacha() -> String:
	var all_cosmetics: Array = Data.inventory.keys()
	while true:
		var random_cos: String = all_cosmetics.pick_random()
		if not Data.inventory[random_cos]:
			print("new: %s"%random_cos)
			Data.inventory[random_cos] = true # add to inventory
			Data.save_game()
			return random_cos
		else:
			print("old: %s"%random_cos)
			all_cosmetics.erase(random_cos)

	## It should never reach here
	## But just in case I put bowtie_blue so it doesn't break
	return "bowtie_blue"


func _count_inventory() -> int:
	var item_amount = 0
	for i in Data.inventory:
		if Data.inventory[i]:
			item_amount += 1
	return item_amount


func _spawn_bowtie_gacha(_type, _color) -> void:
	var bowtie = BOWTIE_TYPE.instantiate()
	bowtie.bowtie_type = _type
	bowtie.color = _color
	add_child(bowtie)
	bowtie.play_dance()


func _spawn_hips_gacha(_type, _color) -> void:
	var bowtie = HIPS_TYPE.instantiate()
	bowtie.bowtie_type = _type
	bowtie.color = _color
	add_child(bowtie)
	bowtie.play_dance()


func _determine_cosmetic_type(_cosmetic: String) -> String:
	var bowtie_type = ["bowtie", "gura", "skull"]
	var hips_type = ["gun", "kunai", "pouch"]

	if _cosmetic in bowtie_type:
		return "bowtie"
	
	if _cosmetic in hips_type:
		return "hips"
	
	return "Error"


## Used by AnimationPlayer
func _spawn_hit_spark_fireball () -> void:
	var hit_spark = HIT_SPARK_FIREBALL.instantiate()
	add_child(hit_spark)

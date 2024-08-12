extends Node2D


#############################################################
## Preloads
#############################################################
const BOWTIE_TYPE = preload("res://nodes/cosmetics/bowtie_type.tscn")
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
	print(Data.inventory["gura_blue"])


#############################################################
## Public functions
#############################################################
func run_gacha() -> void:
	var the_thing = _random_gacha()
	var parts = the_thing.split("_")
	_spawn_bowtie_gacha(parts[0], parts[1])
	animation_player.play("run_gacha")
	label_player.play("pop_in")


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


func _spawn_bowtie_gacha(_type, _color) -> void:
	var bowtie = BOWTIE_TYPE.instantiate()
	bowtie.bowtie_type = _type
	bowtie.color = _color
	add_child(bowtie)
	bowtie.play_dance()


## Used by AnimationPlayer
func _spawn_hit_spark_fireball () -> void:
	var hit_spark = HIT_SPARK_FIREBALL.instantiate()
	add_child(hit_spark)

extends Node2D

const HIT_SPARK_BLUE = preload("res://nodes/particles_effects/hit_spark_blue.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _spawn_hit_spark() -> void:
	var hit_spark = HIT_SPARK_BLUE.instantiate()
	add_child(hit_spark)


func play_pop_up() -> void:
	animation_player.play("pop_up")


func play_pop_down() -> void:
	animation_player.play("pop_down")

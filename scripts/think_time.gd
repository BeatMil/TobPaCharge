extends Node2D

#################################################
## Preloads
#################################################
const HIT_SPARK_BLUE = preload("res://nodes/particles_effects/hit_spark_blue.tscn")


#################################################
## Config
#################################################
@export var time_to_think: float = 1.00


#################################################
## Nodes
#################################################
@onready var vanilla = $Vanilla
@onready var kaisouko = $Kaisouko
@onready var left_marker_2d = $LeftMarker2D
@onready var mid_marker_2d = $MidMarker2D
@onready var right_marker_2d = $RightMarker2D
@onready var vanilla_marker_2d = $VanillaMarker2D
@onready var kaisouko_marker_2d = $KaisoukoMarker2D


#################################################
## Notifications
#################################################
func _ready() -> void:
	pass



#################################################
## Public function
#################################################
func start_think_time() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(vanilla, "position", left_marker_2d.position, time_to_think)
	tween.parallel().tween_property(kaisouko, "position", right_marker_2d.position, time_to_think)
	tween.tween_callback(_spawn_blue_hit_spark)
	tween.tween_property(vanilla, "position", vanilla_marker_2d.position, 0.3).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(kaisouko, "position", kaisouko_marker_2d.position, 0.3).set_trans(Tween.TRANS_BACK)


#################################################
## Private function
#################################################
func _spawn_blue_hit_spark() -> void:
	var hit_spark = HIT_SPARK_BLUE.instantiate()
	hit_spark.position = mid_marker_2d.position
	add_child(hit_spark)

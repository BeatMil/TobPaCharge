extends Node2D


########################################
# Nodes References
########################################
@onready var charge1: Polygon2D = $charge1
@onready var charge2: Polygon2D = $charge2
@onready var charge3: Polygon2D = $charge3


########################################
# Notification
########################################
func _ready():
	await get_tree().create_timer(0.5).timeout
	charge1.get_node("AnimationPlayer").play("pop_up")


########################################
# public function
########################################
func run_charge_animation(current_charge: int):
	if current_charge == 1:
		charge1.get_node("AnimationPlayer").play("pop_up")
		charge2.get_node("AnimationPlayer").play("RESET")
		charge3.get_node("AnimationPlayer").play("RESET")
	elif current_charge == 2:
		charge1.get_node("AnimationPlayer").play("upped")
		charge2.get_node("AnimationPlayer").play("pop_up")
		charge3.get_node("AnimationPlayer").play("RESET")
	elif current_charge == 3:
		charge1.get_node("AnimationPlayer").play("upped")
		charge2.get_node("AnimationPlayer").play("upped")
		charge3.get_node("AnimationPlayer").play("pop_up")
	elif current_charge > 3:
		charge1.get_node("AnimationPlayer").play("upped")
		charge2.get_node("AnimationPlayer").play("upped")
		charge3.get_node("AnimationPlayer").play("upped")

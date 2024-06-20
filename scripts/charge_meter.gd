extends Node2D


########################################
# Nodes References
########################################
@onready var charge1: Polygon2D = $charge1
@onready var charge2: Polygon2D = $charge2
@onready var charge3: Polygon2D = $charge3


########################################
# Property
########################################
@onready var charge_polygons: Array = [charge1,charge2,charge3]
var current_charge: int = 0


########################################
# Notification
########################################
func _ready():
	# await get_tree().create_timer(0.5).timeout
	# charge()
	# await get_tree().create_timer(0.5).timeout
	# charge()
	# await get_tree().create_timer(0.5).timeout
	# charge()
	# await get_tree().create_timer(0.5).timeout
	# discharge()
	# await get_tree().create_timer(0.5).timeout
	# discharge()
	# await get_tree().create_timer(0.5).timeout
	# discharge()
	pass


########################################
# public function
########################################
func charge() -> void:
	if current_charge < charge_polygons.size() and current_charge >= 0:
		charge_polygons[current_charge].get_node("AnimationPlayer").play("pop_up")
		current_charge += 1


func discharge() -> void:
	if current_charge <= 0:
		printerr("No charge to spend!")
	else:
		charge_polygons[current_charge-1].get_node("AnimationPlayer").play("pop_down")
		current_charge -= 1


func discharge_big_fireball() -> void:
	if current_charge >= 3:
		for p in charge_polygons:
			p.get_node("AnimationPlayer").play("pop_down")
		current_charge -= 3
	else:
		printerr("Not enough charges!")

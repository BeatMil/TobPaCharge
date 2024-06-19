extends Polygon2D


########################################
# Preloads
########################################
var PARTICLE_EFFECT = preload("res://nodes/particles_effects/hit_spark.tscn")


########################################
# Nodes
########################################
@onready var particle_position: Vector2 = $ParticlePositionMarke2D.position


########################################
# Exports
########################################
@export var select_color: Color


########################################
# Notification
########################################
func _ready():
	color = select_color


########################################
# private function
########################################
func _spawn_particle_effect() -> void:
	var particle = PARTICLE_EFFECT.instantiate()
	particle.position = particle_position
	add_child(particle)

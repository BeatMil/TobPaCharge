extends Node2D
#################################################
## Signals
#################################################
signal animation_finished


#################################################
## Nodes Reference
#################################################
@onready var vanilla_background: Sprite2D = $VanillaBackground
@onready var kaisouko_background: Sprite2D = $KaisoukoBackground
@onready var white_cover_player: AnimationPlayer = $WhiteCover/WhiteCoverPlayer
@onready var black_cover: ColorRect = $BlackCover
@onready var backgrounds_player: AnimationPlayer = $Backgrounds/BackgroundsPlayer
@onready var vanilla_player: AnimationPlayer = $VanillaBackground/VanillaPlayer
@onready var kaisouko_player: AnimationPlayer = $KaisoukoBackground/KaisoukoPlayer
@onready var vanilla_sfx_player: AnimationPlayer = $VanillaBackground/VanillaSfxPlayer
@onready var kaisouko_sfx_player: AnimationPlayer = $KaisoukoBackground/KaisoukoSfxPlayer
@onready var music_player: AnimationPlayer = $MusicPlayer


#################################################
## Built-in
#################################################
func _ready() -> void:
	white_cover_player.play("cover")
	vanilla_background.offset.x = -800
	kaisouko_background.offset.x = 1100
	run_intro()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#################################################
## Public function
#################################################
func run_intro() -> void:
	_run_kaisouko_tween()
	await get_tree().create_timer(0.2).timeout
	_run_vanilla_tween()
	await get_tree().create_timer(1).timeout
	white_cover_player.play("faint")
	music_player.play("menu_song")
	black_cover.set_deferred("visible", false)
	backgrounds_player.play("normal")
	vanilla_player.play("normal")
	kaisouko_player.play("normal")
	emit_signal("animation_finished")


#################################################
## Helpers
#################################################
func _run_kaisouko_tween() -> void:
	kaisouko_background.offset.x = 1100
	var tween = get_tree().create_tween()
	tween.tween_property(kaisouko_background, "offset", Vector2.ZERO, 1).set_trans(Tween.TRANS_BACK)
	await get_tree().create_timer(0.5).timeout
	kaisouko_sfx_player.play("normal")


func _run_vanilla_tween() -> void:
	var tween = get_tree().create_tween()
	vanilla_background.offset.x = -800
	tween.tween_property(vanilla_background, "offset", Vector2.ZERO, 1).set_trans(Tween.TRANS_BACK)
	await get_tree().create_timer(0.5).timeout
	vanilla_sfx_player.play("normal")

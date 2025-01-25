extends Node2D
@onready var play_again: Sprite2D = $PlayAgain
@onready var fog: Sprite2D = $Fog
@onready var play_again_2: Sprite2D = $PlayAgain2
@onready var diver_1: CharacterBody2D = $Diver1
@onready var diver_2: CharacterBody2D = $Diver2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.connect("bubble_released", on_bubble_detach)
	Manager.connect("players_released", on_player_detach)
	Manager.connect("end_game", on_end_game)
	
	fog.modulate.a = 0
	play_again.modulate.a = 0
	play_again_2.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Manager.ended and diver_1.balloon.value + diver_2.balloon.value <= 0:
		Engine.time_scale *= 0.957
		fog.modulate.a = lerp(fog.modulate.a, 1.0, 0.02)
		play_again.modulate.a = lerp(play_again.modulate.a, 1.0, 0.001)
		play_again_2.modulate.a = lerp(play_again_2.modulate.a, 1.0, 0.03)

	if play_again_2.modulate.a > 0.98 and Input.is_anything_pressed():
		Manager.ended = false
		Engine.time_scale = 1.0
		get_tree().reload_current_scene()

func on_bubble_detach(bubble):
	bubble.reparent(self)

func on_player_detach(bubble):
	for child in bubble.players.get_children():
		var gpos = bubble.global_position
		child.reparent(self)
		child.global_position = gpos
		child.caught = false
		Manager.add_score(bubble.creator, 1)
	bubble.crash()
	await get_tree().create_timer(0.05).timeout
	bubble.queue_free()

func on_end_game():
	print(Manager.scores)

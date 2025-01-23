extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.connect("bubble_released", on_bubble_detach)
	Manager.connect("players_released", on_player_detach)
	Manager.connect("end_game", on_end_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Manager.ended:
		Engine.time_scale *= 0.95

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

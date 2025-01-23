extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.connect("bubble_released", on_bubble_detach)
	Manager.connect("players_released", on_player_detach)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_bubble_detach(bubble):
	bubble.reparent(self)

func on_player_detach(bubble):
	for child in bubble.players.get_children():
		var gpos = bubble.global_position
		child.reparent(self)
		child.global_position = gpos
		child.caught = false
	bubble.crash()
	await get_tree().create_timer(0.05).timeout
	bubble.queue_free()

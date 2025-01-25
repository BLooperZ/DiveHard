extends Node2D

@export var player_name = "0"
@onready var labels: Control = $Labels



func _ready() -> void:
	Manager.connect("score_changed", on_score_changed)
	

func on_score_changed(score_player_name):
	var text = str(Manager.scores[player_name])
	for label in labels.get_children():
		label.text = text

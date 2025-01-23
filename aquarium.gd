extends Node2D

@onready var player = $Diver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("detach_bubble", on_bubble_detach)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_bubble_detach(bubble):
	bubble.reparent(self)

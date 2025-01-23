extends Area2D

@onready var caught = false

@export var min_scale = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_scale = Vector2(1.0, 1.0)
	if caught:
		print(position, global_position)
		position = lerp(position, Vector2(0.0, 0.0), 0.1)

func _on_area_entered(area: Area2D) -> void:
	if not caught and area.scale.x >= min_scale:
		var gpos = global_position
		self.reparent(area)
		global_position = gpos
		caught = true

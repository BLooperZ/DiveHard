extends Area2D

const MAX_SIZE = 0.9
const INITIAL_SCALE = 0.01
const GROWTH_RATE = 0.01



@onready var released = false
@onready var velocity = Vector2(60 , 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ONE * INITIAL_SCALE

func release() -> void:
	released = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if not released:
		scale.x = move_toward(scale.x, MAX_SIZE, GROWTH_RATE)
		scale.y = move_toward(scale.y, MAX_SIZE, GROWTH_RATE)
		position += velocity * delta
	else:
		velocity = lerp(velocity, Vector2(0, -120), 0.08)
		scale.x = move_toward(scale.x, MAX_SIZE * 2, GROWTH_RATE * 0.1)
		scale.y = move_toward(scale.y, MAX_SIZE * 2, GROWTH_RATE * 0.1)
		position += velocity * delta

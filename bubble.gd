extends Area2D

const MAX_SIZE = 0.8
const INITIAL_SCALE = 0.01
const GROWTH_RATE = 0.6

@onready var released = false
@onready var velocity = Vector2(60 , 0)
@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D
@onready var xscale = INITIAL_SCALE
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var treasures = $Captured/Treasures
@onready var players = $Captured/Players

@onready var crashed = false

@onready var creator = null

var t = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_cscale(INITIAL_SCALE)
	#sprite.scale = Vector2.ONE * INITIAL_SCALE
	#collision.scale = Vector2.ONE * INITIAL_SCALE

func set_cscale(nscale) -> void:
	sprite.scale = 0.5 * Vector2(nscale, nscale)
	collision.scale = Vector2(nscale, nscale)

func release() -> void:
	collision_layer = 2
	released = true
	Manager.detach_bubble(self)
	sprite.modulate.a = 1
	audio_player.stop()
	#sprite.modulate = Color(255, 0, 10, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if crashed:
		xscale *= 1.1
	elif not released:
		xscale = move_toward(xscale, MAX_SIZE, GROWTH_RATE * delta)
		position += velocity * delta
		if xscale >= MAX_SIZE * 0.98:
			release()
	else:
		velocity = lerp(velocity, Vector2(0, -120), 0.08)
		xscale = move_toward(xscale, MAX_SIZE * 2, GROWTH_RATE * 0.1 * delta)
		position += velocity * delta
		t += delta
		xscale += 0.001 * cos(8 * t)
	set_cscale(xscale)


func _on_body_entered(body: Node2D) -> void:
	if not released:
		body.on_area_entered(self)
#

func crash():
	crashed = true

func explode():
	for child in treasures.get_children():
		print(child)
		child.queue_free()
	
	audio_player.stream = load("res://explode_bubble.wav")
	audio_player.pitch_scale = (1.5 - xscale)
	audio_player.play()
	Manager.take_captured(self)

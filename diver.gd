extends CharacterBody2D

const SPEED = 50.0
const ROTATION_SPEED = 3.0
const SMOOTHNESS = 0.4
const DRAG = 0.97

signal detach_bubble(bubble)

@onready var bubble = null


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


	var target_velocity = velocity + direction * SPEED
	velocity = lerp(velocity, target_velocity, SMOOTHNESS)
	velocity *= DRAG

	if velocity.y > 0:  # Moving down is harder
		velocity.y *= DRAG

	# Rotate player to face the movement direction smoothly
	if direction != Vector2.ZERO:
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, target_angle, ROTATION_SPEED * delta)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if bubble == null and event.is_action_pressed("ui_accept"):
		
		var bubble_scene = load("res://Bubble.tscn")
		bubble = bubble_scene.instantiate()
		add_child(bubble)
	if bubble != null and event.is_action_released("ui_accept"):
		bubble.release()
		bubble.velocity = 2 * velocity
		emit_signal("detach_bubble", bubble)
		bubble = null

func _on_signal(bubble):
	print(bubble)

extends Area2D

@onready var diver_in_area = false

func _on_Area2D_body_entered(body):
	if body.name == "Diver":
		
		body.add_air(50, 0.016)  ### 0.016 is delta substitute for 60fps
		print ("adding air")
		

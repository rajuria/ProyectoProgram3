extends Area2D

var speed = 400

func _ready():
	add_to_group("Arrow")

func _physics_process(delta):
	position += transform.x*speed*delta
	



func _on_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.Health=0
		queue_free()
	queue_free()
	

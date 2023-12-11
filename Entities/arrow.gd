extends Area2D

var speed = 300

func _ready():
	add_to_group("Arrow")

func _physics_process(delta):
	position += transform.x*speed*delta
	



func _on_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.Health=0
		queue_free()
	if(body.is_in_group("Boss")):
		body.Health-=5
		body.Hurt()
		queue_free()
	queue_free()
	

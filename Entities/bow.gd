extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player") and not Global.LinkCanShoot:
		Global.LinkCanShoot=true
		self.visible=false
		$ItemAcquired.play()

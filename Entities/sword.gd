extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player") and not Global.LinkHasSword:
		Global.LinkHasSword=true
		Global.PlaySwordAnimation=true
		self.visible=false
		$ItemAcquired.play()
		#body.AnimatedSprite.play("GotSword")

extends CanvasLayer

func _ready():
	$Player.AnimatedSprite.play("DeadLink")

func _on_quit_pressed():
	get_tree().quit()


func _on_retry_pressed():
	Global.LinkIsDead=false
	get_tree().change_scene_to_file("res://WorldScenes/overworld.tscn")

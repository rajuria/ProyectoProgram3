extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://WorldScenes/overworld.tscn")


func _on_developer_options_pressed():
	get_tree().change_scene_to_file("res://developer_options.tscn")

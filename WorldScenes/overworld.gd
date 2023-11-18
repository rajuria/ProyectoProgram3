extends Node2D
var current_scene = "overworld"
var change_scene = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_cave_body_entered(body):
	if body.is_in_group("Player"):
		change_scene = true
		change_scenes()

func change_scenes():
	if change_scene == true:
		if current_scene == "overworld":
			get_tree().change_scene_to_file("res://WorldScenes/cave.tscn")

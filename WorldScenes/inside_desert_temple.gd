extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.LinkCanShoot:
		$TileMap/Bow.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_overworld_body_entered(body):
	if body.is_in_group("Player"):
		Global.LastOverworldPosition = Global.LastOverworldPosition+Vector2(0,-10)
		get_tree().change_scene_to_file("res://WorldScenes/overworld.tscn")

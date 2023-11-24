extends Node2D
var current_scene = "overworld"
var change_scene = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.LastOverworldPosition!=Vector2(0,0):
		$TileMap/Player.position = Global.LastOverworldPosition+Vector2(0,5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_cave_body_entered(body):
	if body.is_in_group("Player"):
		Global.LastOverworldPosition = $TileMap/Player.position
		change_scene = true
		change_scenes()

func change_scenes():
	if change_scene == true:
		if current_scene == "overworld":
			get_tree().change_scene_to_file("res://WorldScenes/cave.tscn")



func _on_desert_music_trigger_body_entered(body):
	if body.is_in_group("Player") and not $DesertMusic.playing:
		$DesertMusic.play()
		$StartingAreaMusic.stop()
		$TundraMusic.stop()



func _on_starting_music_trigger_body_entered(body):
	if body.is_in_group("Player") and not $StartingAreaMusic.playing:
		$StartingAreaMusic.play()
		$DesertMusic.stop()
		$TundraMusic.stop()


func _on_tundra_music_trigger_body_entered(body):
	if body.is_in_group("Player") and not $TundraMusic.playing:
		$StartingAreaMusic.stop()
		$DesertMusic.stop()
		$TundraMusic.play()

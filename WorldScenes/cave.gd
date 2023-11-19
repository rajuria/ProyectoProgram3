extends Node2D

var change_scene = false
var current_scene = "cave"

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.LinkHasSword:
		$Sword.queue_free()
	if not Global.StartingDialogue:
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/CaveDialogue.dialogue"),"start")
		Global.StartingDialogue=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.PlaySwordAnimation:
		$Player.velocity=Vector2.ZERO
		$Player.AnimatedSprite.play("GotSword")
		await get_tree().create_timer(1.5).timeout
		Global.PlaySwordAnimation=false

func change_scenes():
	if change_scene == true:
		if current_scene == "cave":
			get_tree().change_scene_to_file("res://WorldScenes/overworld.tscn")



func _on_overworld_body_entered(body):
	if body.is_in_group("Player"):
		change_scene = true
		change_scenes()

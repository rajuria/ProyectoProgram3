extends CharacterBody2D




func _on_territory_body_entered(body):
	if body.is_in_group("Player"):
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/DesertMaiden1.dialogue"),"start")

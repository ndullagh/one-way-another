extends Area2D

#Cutscene 6 for level 3

@onready var textbox = $/root/Node2D/Textbox
@onready var music_player_1 = $/root/Node2D/AudioStreamPlayer
@onready var music_player_2 = $/root/Node2D/AudioStreamPlayer2

@onready var character_inside = false
@onready var initialized = false

func _ready():
	body_entered.connect(_on_body_entered)
	initialized = true

var music_tween: Tween

func _on_body_entered(body):
	#ensure it's the player and that the cutscene hasn't been seen yet
	if body is CharacterBody2D:  # THIS WILL NEED TO CHANGE IF PLAYER IS NO LONGER THE ONLY CHARACTER_BODY_2D
		textbox.queue_text("Level 1 Completion Cutscene Placeholder")
		
		#bandaid fix so that the ending screen doesn't immediately show when the final cutscene starts. it's stupid just don't touch it
		character_inside = true
		
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if initialized and character_inside:
		print("Current state: ", textbox.current_state)
		print("Text queue empty: ", textbox.text_queue.is_empty())
		print("Character inside: ", character_inside)
		
		if textbox.current_state == textbox.State.READY and textbox.text_queue.is_empty():
			get_tree().change_scene_to_file("res://scenes/main/levels/level 3/node_2d.tscn")

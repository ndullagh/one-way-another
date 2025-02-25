extends Area2D

#Script for causing the player to die when entering a death zone

@onready var death_screen = $/root/Node2D/death_screen
@onready var textbox = $/root/Node2D/Textbox


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

#when player enters, kill player
func _on_body_entered(body):
	print("ENTERED")
	if body is CharacterBody2D:  # IF PLAYER IS NO LONGER THE *ONLY* CHARCTER_BODY_2D, THIS WILL NEED TO CHANGE
		body.die()
		death_screen.show_death_screen()
		textbox.text_queue = []
		textbox.hide_textbox()
		textbox.current_state = textbox.State.READY
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

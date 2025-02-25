extends Area2D

#Cutscene 5 for level 3

@onready var textbox = $/root/Node2D/Textbox

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	#ensure it's the player and that the cutscene hasn't been seen yet
	if body is CharacterBody2D and not GameState.has_seen_dialogue(5):  # # THIS WILL NEED TO CHANGE IF PLAYER IS NO LONGER THE ONLY CHARACTER_BODY_2D
		
		GameState.mark_dialogue_as_seen(5) # mark as seen
		
		textbox.queue_text("Kol: These look just like Evelyn's did! Shame they're all broken, though.", "res://cutscenes/c4/1.png" )
		textbox.queue_text("Kol: I can't wait to see her again. It's so snowy and smoggy all the time - I can never tell how long it's been. Years? Decades?")
		textbox.queue_text("Kol: Wow, I must've aged well if it's been that long!")
		queue_free()
		
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

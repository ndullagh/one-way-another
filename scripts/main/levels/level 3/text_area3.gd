extends Area2D

#Cutscene 3 for level 3

@onready var textbox = $/root/Node2D/Textbox

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	#ensure it's the player and that the cutscene hasn't been seen yet
	if body is CharacterBody2D and not GameState.has_seen_dialogue(3):  # THIS WILL NEED TO CHANGE IF PLAYER IS NO LONGER THE ONLY CHARACTER_BODY_2D
		
		GameState.mark_dialogue_as_seen(3) #mark as seen
		
		textbox.queue_text("Kol: There used to be an ocean past the city. You used to be able to see teeeeny sliver of it just on the horizon.",  "res://cutscenes/c3/1.png")
		textbox.queue_text("Kol: Now it's just empty buildings falling apart. It feels like more of them pop up every day.")
		textbox.queue_text("Kol: I miss when they had people in them.")
		queue_free()
		
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

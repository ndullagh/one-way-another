extends Area2D

#Cutscene 2 for level 3

@onready var textbox = $/root/Node2D/Textbox

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	#ensure it's the player and that the cutscene hasn't been seen yet
	if body is CharacterBody2D and not GameState.has_seen_dialogue(2):  # THIS WILL NEED TO CHANGE IF PLAYER IS NO LONGER THE ONLY CHARACTER_BODY_2D
		
		GameState.mark_dialogue_as_seen(2) #mark as seen
		
		
		textbox.queue_text("Kol: I never really saw Evelyn again after the war started. When I was conscripted I was... scared, but she promised I'd be okay.",  "res://cutscenes/c2/1.png")
		textbox.queue_text("Kol: I guess she meant it since I'm still here! Honestly, I'm not sure anyone left even remembers what the war was about...")
		textbox.queue_text("Kol: ...I sure don't! Come to think of it, it's been a while since I've seen anyone.")
		queue_free()
		
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

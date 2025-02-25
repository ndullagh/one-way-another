extends Area2D

#Cutscene 1 (intro) for level 3

@onready var textbox = $/root/Node2D/Textbox
@onready var music_player = $/root/Node2D/AudioStreamPlayer


func _ready():
	body_entered.connect(_on_body_entered)
	#$/root/Node2D/AudioStreamPlayer.loop = true
	#$/root/Node2D/AudioStreamPlayer2.loop = true

func _on_body_entered(body):
	if not music_player.playing:
			music_player.play()  # starts playing if it isn't already
			
	#ensure it's the player and that the cutscene hasn't been seen yet
	if body is CharacterBody2D and not GameState.has_seen_dialogue(1):  # THIS WILL NEED TO CHANGE IF PLAYER IS NO LONGER THE ONLY CHARACTER_BODY_2D
		
		
		
		textbox.queue_text("Kol: I can't believe I'm almost there! Getting through this city never used to be such a pain.", "res://cutscenes/c1/1.png")
		textbox.queue_text("Kol: It'll be worth it though. It's crazy, really. I haven't seen her in, well, who knows how long, even though she practically raised me.")
		textbox.queue_text("Kol: Her signal's getting closer. It has to be coming from just up ahead!",  "res://cutscenes/c1/2.png")
		GameState.mark_dialogue_as_seen(1)
		queue_free()
		
		
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

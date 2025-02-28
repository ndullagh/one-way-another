extends Area2D

#Cutscene 3 for level 3

@onready var textbox = $/root/Node2D/Textbox
@onready var sprite = $Sprite2D
@onready var enter_prompt = $AnimatedSprite2D

@onready var music_player_1 = $/root/Node2D/AudioStreamPlayer
@onready var music_player_2 = $/root/Node2D/AudioStreamPlayer2

@onready var initialized = false

@onready var triggered_once = false

var player_inside = null
var cutscene_triggered = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	enter_prompt.hide()
	initialized = true

var music_tween: Tween

func _on_body_entered(body):
	#ensure it's the player and that the cutscene hasn't been seen yet
	if body.is_in_group("Player"):  
		player_inside = body  # Store player reference
		set_outline(true)
		enter_prompt.show()
		enter_prompt.play("default")
	print(cutscene_triggered)
		
		
func _on_body_exited(body):
	# Remove reference when player leaves
	if body == player_inside:
		player_inside = null
		set_outline(false)
		enter_prompt.stop()
		enter_prompt.hide()
	print(cutscene_triggered)
	
func set_outline(enable: bool):
	if enable:
		sprite.self_modulate = Color(1.2, 1.2, 1.2, 1)  # Brighten the sprite slightly
	else:
		sprite.self_modulate = Color(1, 1, 1, 1)  # Reset to normal colo
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check for input only if player is inside
	if player_inside and Input.is_action_just_pressed("Enter") and not cutscene_triggered:
		cutscene_triggered = true
		
		
		#end old music
		if music_tween:
			music_tween.kill()
			
		music_tween = get_tree().create_tween()
		
		
		textbox.queue_text("Kol: Wow... I never thought I'd actually get to her. Is this where she's been staying while I've been away?",  "res://cutscenes/c5/1.png") #-standing outside
		textbox.queue_text("Kol: I knew she was smart, but I didn't know she'd been working in a robotics lab this whole time...")
		textbox.queue_text("Kol: Well, it's now or never!")
		textbox.queue_text("Kol: Ev...? Are you in here? I heard your signal...", "res://cutscenes/c5/2.png") #establishing shot
		textbox.queue_text("Kol: ...What the...", "res://cutscenes/c5/3.png") #sees pod
		textbox.queue_text("Kol: Is... Is that...", "res://cutscenes/c5/4.png") #wipe
		textbox.queue_text("Kol: ...me...?") # reaction
		textbox.queue_text("[STATIC]")
		textbox.queue_text("Kol: -!", "res://cutscenes/c5/5.png") # turns around and sees hologram
		textbox.queue_text("Evelyn: K- a l?/>; lum;.,- c an you he a r me?", "res://cutscenes/c5/6.png") 
		textbox.queue_text("Kol: Kallum? Why do I know that name...?")
		textbox.queue_text("Kol: ...", "res://cutscenes/c5/7.png")
		textbox.queue_text("Kol: ...!", "res://cutscenes/c5/8.png") #sees name on pod
		textbox.queue_text("Evelyn: Kallum... if this recording is playing, it must be you.", "res://cutscenes/c5/9.png") #ev talking
		textbox.queue_text("Evelyn: I'm sorry I couldn't be there in person. The city keeps warping - distorting - falling apart. Things are getting dire.")
		textbox.queue_text("Evelyn: There's no saving it now. I tried to at least save you.")
		textbox.queue_text("Kol: Save... me...?", "res://cutscenes/c5/10.png") #kol reaction?
		textbox.queue_text("Kol: N-no...")
		textbox.queue_text("Evelyn: I tried to ensure some part of you would be left behind after it was over. Even if it was a copy. A machine.", "res://cutscenes/c5/9.png") #ev talking
		textbox.queue_text("Evelyn: They... they want to keep remaking the copy of you I made. Automating it so another comes to fight every time you die.")
		textbox.queue_text("Evelyn: I can't stop them. I'm sorry, Kal. I can't bear to destroy the only thing that will be left of you. I'm sorry.")
		textbox.queue_text("Evelyn: They're going to take more of your memories each time you die. You won't... remember much about yourself. About me. About the war.")
		textbox.queue_text("Evelyn: It's... for the sake of your own sanity.")
		textbox.queue_text("Evelyn: I hope you're safe now. You're a good kid, Kal. I know you'll be just fine.")
		textbox.queue_text("Kol: Please don't go... you're the only thing I have left-!", "res://cutscenes/c5/11.png") #kol tearing up
		textbox.queue_text("Evelyn: I love you, Kallum. Goodbye.", "res://cutscenes/c5/12.png") #ev fades out
		textbox.queue_text("...", "res://cutscenes/c5/13.png") #kol falls to knees
		textbox.queue_text("Kol: HOW?! HOW C-COULD YOU-! *hic* IT'S NOT FAIR! IT'S NOT FAIR IT'S NOT FAIRIT'SNOTFAIRIT'SNOTFAIR!!!!", "res://cutscenes/c5/14.png")
		textbox.queue_text("Kol: YOU C-CAN'T LEAVE ME HERE!! NOT AGAIN! I CAN'T BE ALL ALONE AGAIN, PLEASE-!")
		textbox.queue_text("Kol: Y-you can't... You can't. not like this.", "res://cutscenes/c5/15.png") #quieter expression?
		textbox.queue_text("Kol: I don't deserve to go through this again.", "res://cutscenes/c5/16.png") # just smile
		textbox.queue_text("Kol: I'm sorry, Ev. Thank you for everything.", "res://cutscenes/c5/17.png") # grabs pipe
		textbox.queue_text("", "res://cutscenes/c5/18.png")
		textbox.queue_text("*CRASH*", "res://cutscene/overall/bg0.png") #destroys pods
		textbox.queue_text("*SLAM*")
		textbox.queue_text("*CRUNCH*")
		textbox.queue_text("Kol: ...")
		textbox.queue_text("Kol: What am I even supposed to do now? What's left for me out there? I'm not even real anymore. A copy of a copy of... someone. Of Kallum.")
		textbox.queue_text("Kol: ...?", "res://cutscenes/c5/19.png")
		textbox.queue_text("\" Whatever you do, keep helping people. That's the kind of person you've always been. If you don't, who will? - Ev\"", "res://cutscenes/c5/20.png") # reads note
		textbox.queue_text("Kol: ...") # eyes close
		textbox.queue_text("Kol: *sigh*", "res://cutscene/overall/bg0.png") #black
		textbox.queue_text("Kol: I guess I can see this out a little longer. Maybe there's someone out there who needs me.") #outside looking over horizon
		textbox.queue_text("")
		textbox.queue_text("[THE END]")
		
		triggered_once = true
		
		#fade in new music
		music_player_2.volume_db = -40  # start silent
		music_player_2.play()
		 # crossfade
		music_tween.parallel().tween_property(music_player_1, "volume_db", -40, 3)  # out
		music_tween.parallel().tween_property(music_player_2, "volume_db", 0, 3)   # in
		
		await music_tween.finished
		music_player_1.stop()
		
	if textbox.current_state == textbox.State.READY and textbox.text_queue.is_empty():
		cutscene_triggered = false
	
	if initialized and player_inside and triggered_once:
		print("Current state: ", textbox.current_state)
		print("Text queue empty: ", textbox.text_queue.is_empty())
		print("Player inside: ", player_inside)
		
		if textbox.current_state == textbox.State.READY and textbox.text_queue.is_empty():
			get_tree().change_scene_to_file("res://scenes/UI/credits.tscn")
		


'''extends Area2D

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
	if body.is_in_group("Player"):  # THIS WILL NEED TO CHANGE IF PLAYER IS NO LONGER THE ONLY CHARACTER_BODY_2D
		
		#don't need to mark as seen since this is the ending lol
		
		#end old music
		if music_tween:
			music_tween.kill()
			
		music_tween = get_tree().create_tween()
		
		
		textbox.queue_text("Kol: Wow... I never thought I'd actually get to her. Is this where she's been staying while I've been away?",  "res://cutscenes/c5/1.png") #-standing outside
		textbox.queue_text("Kol: I knew she was smart, but I didn't know she'd been working in a robotics lab this whole time...")
		textbox.queue_text("Kol: Well, it's now or never!")
		textbox.queue_text("Kol: Ev...? Are you in here? I heard your signal...", "res://cutscenes/c5/2.png") #establishing shot
		textbox.queue_text("Kol: ...What the...", "res://cutscenes/c5/3.png") #sees pod
		textbox.queue_text("Kol: Is... Is that...", "res://cutscenes/c5/4.png") #wipe
		textbox.queue_text("Kol: ...me...?") # reaction
		textbox.queue_text("[STATIC]")
		textbox.queue_text("Kol: -!", "res://cutscenes/c5/5.png") # turns around and sees hologram
		textbox.queue_text("Evelyn: K- a l?/>; lum;.,- c an you he a r me?", "res://cutscenes/c5/6.png") 
		textbox.queue_text("Kol: Kallum? Why do I know that name...?")
		textbox.queue_text("Kol: ...", "res://cutscenes/c5/7.png")
		textbox.queue_text("Kol: ...!", "res://cutscenes/c5/8.png") #sees name on pod
		textbox.queue_text("Evelyn: Kallum... if this recording is playing, it must be you.", "res://cutscenes/c5/9.png") #ev talking
		textbox.queue_text("Evelyn: I'm sorry I couldn't be there in person. The city keeps warping - distorting - falling apart. Things are getting dire.")
		textbox.queue_text("Evelyn: There's no saving it now. I tried to at least save you.")
		textbox.queue_text("Kol: Save... me...?", "res://cutscenes/c5/10.png") #kol reaction?
		textbox.queue_text("Kol: N-no...")
		textbox.queue_text("Evelyn: I tried to ensure some part of you would be left behind after it was over. Even if it was a copy. A machine.", "res://cutscenes/c5/9.png") #ev talking
		textbox.queue_text("Evelyn: They... they want to keep remaking the copy of you I made. Automating it so another comes to fight every time you die.")
		textbox.queue_text("Evelyn: I can't stop them. I'm sorry, Kal. I can't bear to destroy the only thing that will be left of you. I'm sorry.")
		textbox.queue_text("Evelyn: They're going to take more of your memories each time you die. You won't... remember much about yourself. About me. About the war.")
		textbox.queue_text("Evelyn: It's... for the sake of your own sanity.")
		textbox.queue_text("Evelyn: I hope you're safe now. You're a good kid, Kal. I know you'll be just fine.")
		textbox.queue_text("Kol: Please don't go... you're the only thing I have left-!", "res://cutscenes/c5/11.png") #kol tearing up
		textbox.queue_text("Evelyn: I love you, Kallum. Goodbye.", "res://cutscenes/c5/12.png") #ev fades out
		textbox.queue_text("...", "res://cutscenes/c5/13.png") #kol falls to knees
		textbox.queue_text("Kol: HOW?! HOW C-COULD YOU-! *hic* IT'S NOT FAIR! IT'S NOT FAIR IT'S NOT FAIRIT'SNOTFAIRIT'SNOTFAIR!!!!", "res://cutscenes/c5/14.png")
		textbox.queue_text("Kol: YOU C-CAN'T LEAVE ME HERE!! NOT AGAIN! I CAN'T BE ALL ALONE AGAIN, PLEASE-!")
		textbox.queue_text("Kol: Y-you can't... You can't. not like this.", "res://cutscenes/c5/15.png") #quieter expression?
		textbox.queue_text("Kol: I don't deserve to go through this again.", "res://cutscenes/c5/16.png") # just smile
		textbox.queue_text("Kol: I'm sorry, Ev. Thank you for everything.", "res://cutscenes/c5/17.png") # grabs pipe
		textbox.queue_text("", "res://cutscenes/c5/18.png")
		textbox.queue_text("*CRASH*", "res://cutscene/overall/bg0.png") #destroys pods
		textbox.queue_text("*SLAM*")
		textbox.queue_text("*CRUNCH*")
		textbox.queue_text("Kol: ...")
		textbox.queue_text("Kol: What am I even supposed to do now? What's left for me out there? I'm not even real anymore. A copy of a copy of... someone. Of Kallum.")
		textbox.queue_text("Kol: ...?", "res://cutscenes/c5/19.png")
		textbox.queue_text("\" Whatever you do, keep helping people. That's the kind of person you've always been. If you don't, who will? - Ev\"", "res://cutscenes/c5/20.png") # reads note
		textbox.queue_text("Kol: ...") # eyes close
		textbox.queue_text("Kol: *sigh*", "res://cutscene/overall/bg0.png") #black
		textbox.queue_text("Kol: I guess I can see this out a little longer. Maybe there's someone out there who needs me.") #outside looking over horizon
		textbox.queue_text("")
		textbox.queue_text("[THE END]")
		
		
		#bandaid fix so that the ending screen doesn't immediately show when the final cutscene starts. it's stupid just don't touch it
		character_inside = true
		
		#fade in new music
		music_player_2.volume_db = -40  # start silent
		music_player_2.play()
		 # crossfade
		music_tween.parallel().tween_property(music_player_1, "volume_db", -40, 3)  # out
		music_tween.parallel().tween_property(music_player_2, "volume_db", 0, 3)   # in
		
		await music_tween.finished
		music_player_1.stop()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if initialized and character_inside:
		print("Current state: ", textbox.current_state)
		print("Text queue empty: ", textbox.text_queue.is_empty())
		print("Character inside: ", character_inside)
		
		if textbox.current_state == textbox.State.READY and textbox.text_queue.is_empty():
			get_tree().change_scene_to_file("res://scenes/UI/credits.tscn")'''

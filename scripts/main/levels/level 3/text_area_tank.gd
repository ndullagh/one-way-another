extends Area2D

#Cutscene 2 for level 3

@onready var textbox = $/root/Node2D/Textbox
@onready var sprite = $Sprite2D
@onready var enter_prompt = $AnimatedSprite2D

var player_inside = null
var cutscene_triggered = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	enter_prompt.hide()

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
		GameState.mark_dialogue_as_seen(2)  # Mark as seen

		textbox.queue_text("Kol: I never really saw Evelyn again after the war started. When I was conscripted I was... scared, but she promised I'd be okay.", "res://cutscenes/c2/1.png")
		textbox.queue_text("Kol: I guess she meant it since I'm still here! Honestly, I'm not sure anyone left even remembers what the war was about...")
		textbox.queue_text("Kol: ...I sure don't! Come to think of it, it's been a while since I've seen anyone.")
		
	if textbox.current_state == textbox.State.READY and textbox.text_queue.is_empty():
		cutscene_triggered = false
		
	

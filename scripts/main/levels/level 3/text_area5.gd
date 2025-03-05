extends Area2D

#Cutscene 5 for level 3

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
		
		textbox.queue_text("Kol: These look just like Evelyn's did! Shame they're all broken, though.", "res://cutscenes/c4/1.png" )
		textbox.queue_text("Kol: I can't wait to see her again. It's so snowy and smoggy all the time - I can never tell how long it's been. Years? Decades?")
		textbox.queue_text("Kol: Wow, I must've aged well if it's been that long!")
		
	if textbox.current_state == textbox.State.READY and textbox.text_queue.is_empty():
		cutscene_triggered = false
		


	

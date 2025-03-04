extends CanvasLayer

#CODE FOR RUNNING CUTSCENES
#currently works by displaying over the screen and freezing the player. When adding new levels this may cause difficulty since it will need to change how it
#references the player based on what level we're in
#This may also be possible by moving the player scene to the root and making it universal if possible? I'm not quite sure.

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/Panel/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/Panel/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/Panel/MarginContainer/HBoxContainer/Label
@onready var background_1 = $Background1
@onready var background_2 = $Background2
@onready var background_0 = $Background0

#bg 1 is in use by default
var current_background = 1

@onready var character = get_node("/root/Node2D2/Flying Kol")
@onready var sprite = get_node("/root/Node2D2/Flying Kol/AnimatedSprite2D")

const CHAR_READ_RATE = 0.03

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var image_queue = []
var tween: Tween  # Store the tween reference

func queue_text(next_text, image_path = null):
	text_queue.push_back(next_text)
	image_queue.push_back(image_path)  #parallel queues for text and path

func _ready() -> void:
	print("Starting state: State.READY")
	hide_textbox()
	background_1.modulate.a = 0.0  #bg starts invisible
	background_2.modulate.a = 0.0
	background_0.hide()

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
				background_0.show()
				
		State.READING:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump"):
				label.visible_ratio = 1.0
				if tween and tween.is_valid():
					tween.kill()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump"):
				change_state(State.READY)
				hide_textbox()
				if text_queue.is_empty():
					character.set_physics_process(true)
					background_1.hide()
					background_2.hide()
					background_0.hide()

func hide_textbox() -> void:
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox() -> void:
	start_symbol.text = "*"
	textbox_container.show()
	character.set_physics_process(false)
	sprite.play("idle_right")
	sprite.position.y = 0
	sprite.scale = Vector2(.5, .5)

func display_text() -> void:
	var next_text = text_queue.pop_front()
	var next_image_path = image_queue.pop_front()
	print(next_image_path)

	label.text = next_text
	change_state(State.READING)
	label.visible_ratio = 0.0
	show_textbox()

	# handle background image change
	if next_image_path:
		change_background(next_image_path)

	if tween and tween.is_valid():
		tween.kill()

	tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")

var background_tween: Tween

func change_background(texture_path: String):
	if background_tween and background_tween.is_valid():
		background_tween.kill()
		
	background_tween = get_tree().create_tween()
	
	#load new texture from path
	print("texture_path: ", texture_path)
	var new_texture = load(texture_path)
	
	#choose texturerect
	#Alternate which bg is used as the new one so that they can fade at the same time
	#if bg 1 currently in use, fade it out and fade in bg 2
	#otherwise, reverse it
	var fade_out_bg = background_1 if current_background == 1 else background_2
	var fade_in_bg = background_2 if current_background == 1 else background_1
	
	#set the new texture of fade-in bg
	fade_in_bg.texture = new_texture
	fade_in_bg.show()  # Make sure the new background is visible before fading in
	fade_in_bg.modulate.a = 0.0  # Start fully transparent
	
	#crossfade
	#'parallel()' allows the two to happen at the same time. neat!
	background_tween.parallel().tween_property(fade_out_bg, "modulate:a", 0.0, 1.0)
	background_tween.parallel().tween_property(fade_in_bg, "modulate:a", 1.0, 1.0)
	
	#swap which one is currently in use
	current_background = 2 if current_background == 1 else 1

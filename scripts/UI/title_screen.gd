extends Node

@onready var screen_container = $screen_container
@onready var title = $screen_container/Panel/title_container/HBoxContainer/Title
@onready var button_container = $screen_container/Panel/button_container
@onready var button = $screen_container/Panel/button_container/VBoxContainer/Button
@onready var button2 = $screen_container/Panel/button_container/VBoxContainer/Button2
@onready var button3 = $screen_container/Panel/button_container/VBoxContainer/Button3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_title_screen()
	# Connect buttons to their respective functions
	button.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)
	button3.pressed.connect(_on_button3_pressed)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_title_screen() -> void:
	title.text = ""
	button.text = ""
	screen_container.hide()
	button_container.hide()
	

func show_title_screen() -> void:
	title.text = "One Way: Another"
	screen_container.show()
	button_container.show()
	button.text = "Begin"
	GameState.clear_dict()
	
func _on_button1_pressed():
	print("Begin pressed!")
	hide_title_screen()
	get_tree().change_scene_to_file("res://scenes/main/levels/level 1(3 duplicate)/node_2d.tscn")

func _on_button2_pressed():
	print("Credits pressed!")
	get_tree().change_scene_to_file("res://scenes/UI/credits.tscn") #switch to credits

func _on_button3_pressed():
	print("Quit pressed!")
	get_tree().quit()  # quit the game

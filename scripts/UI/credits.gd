extends CanvasLayer

@onready var screen_container = $screen_container
@onready var title = $screen_container/Panel/text_container/VBoxContainer/Title
@onready var credits = $screen_container/Panel/text_container/VBoxContainer/Credits
@onready var button = $screen_container/Panel/text_container/VBoxContainer/Button

@onready var click_player = $ClickPlayer

# alled when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	print("Button pressed!")
	click_player.pitch_scale = randf_range(0.8, 1.2)
	click_player.play()
	get_tree().change_scene_to_file("res://scenes/UI/title_screen.tscn")

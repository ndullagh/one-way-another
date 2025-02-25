extends CanvasLayer

#script for the death screen

@onready var you_died = $death_screen_container/Panel/MarginContainer/HBoxContainer/you_died
@onready var restart = $death_screen_container/Panel/MarginContainer2/HBoxContainer/restart
@onready var death_screen_container = $death_screen_container

var is_active = false  # track if death screen is active


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_death_screen()
	is_active = false  # track if death screen is active


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# only check input when death screen is active
	if is_active and Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()  # restart the game


func hide_death_screen() -> void:
	you_died.text = ""
	restart.text = ""
	death_screen_container.hide()

func show_death_screen() -> void:
	you_died.text = "YOU DIED"
	restart.text = "Press [Enter] to Restart"
	death_screen_container.show()
	is_active = true
	
	

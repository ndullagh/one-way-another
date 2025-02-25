extends Node


var seen_dialogues = {}  # dictionary to track which dialogues have been seen

func mark_dialogue_as_seen(dialogue_id: int):
	seen_dialogues[dialogue_id] = true

func has_seen_dialogue(dialogue_id: int) -> bool:
	return seen_dialogues.get(dialogue_id, false)
	
func clear_dict() -> void:
	seen_dialogues = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

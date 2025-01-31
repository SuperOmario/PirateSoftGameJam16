extends MarginContainer

@onready var logo := $VBoxContainer/MarginContainer/Logo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://code/main.tscn")

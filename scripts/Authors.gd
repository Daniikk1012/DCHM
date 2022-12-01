extends Node2D

func _ready():
    $FocusControl.grab_focus()

func _on_BackButton_pressed():
    if get_tree().change_scene('res://scenes/Menu.tscn') != OK:
        assert(false, 'Error: could not switch to menu scene')

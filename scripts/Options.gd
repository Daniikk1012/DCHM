extends Node2D

func _ready():
    $FocusControl.grab_focus()
    $CenterContainer/VBoxContainer/MusicContainer/MusicSlider.value = (
        Shared.music)
    $CenterContainer/VBoxContainer/SoundContainer/SoundSlider.value = (
        Shared.sound)

func _on_BackButton_pressed():
    if get_tree().change_scene('res://scenes/Menu.tscn') != OK:
        push_error('Error: could not switch to menu scene')
        get_tree().quit(1)

func _on_MusicSlider_value_changed(value: float):
    Shared.music = int(value)

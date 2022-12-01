extends Node2D

func _ready():
    $FocusControl.grab_focus()
    $CenterContainer/VBoxContainer/MusicContainer/MusicSlider.value = (
        Shared.music)
    $CenterContainer/VBoxContainer/SoundContainer/SoundSlider.value = (
        Shared.sound)

func _on_BackButton_pressed():
    if get_tree().change_scene('res://scenes/Menu.tscn') != OK:
        assert(false, 'Error: could not switch to menu scene')

func _on_MusicSlider_value_changed(value: float):
    Shared.music = int(value)

func _on_SoundSlider_value_changed(value: float):
    Shared.sound = int(value)

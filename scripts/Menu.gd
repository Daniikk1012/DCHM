extends Node2D

export var game_scene: PackedScene
export var settings_scene: PackedScene

func _ready():
    VisualServer.set_default_clear_color(Color.gray)
    $FocusControl.grab_focus()

    if Shared.score != null:
        $CenterContainer/VBoxContainer/HighScoreLabel.text = (
           'High Score: ' + str(Shared.score))

func _on_StartButton_pressed():
    if get_tree().change_scene_to(game_scene) != OK:
        push_error('Error: could not switch to the game scene')
        get_tree().quit(1)

func _on_OptionsButton_pressed():
    if get_tree().change_scene_to(settings_scene) != OK:
        push_error('Error: could not switch to the settings scene')
        get_tree().quit(1)

func _on_ExitButton_pressed():
    get_tree().quit()

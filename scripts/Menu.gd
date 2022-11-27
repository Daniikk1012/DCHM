extends Node2D

export var game_scene: PackedScene

func _ready():
    MenuMusicPlayer.play()
    VisualServer.set_default_clear_color(Color.gray)
    $FocusControl.grab_focus()

    var file := File.new()

    match file.open('user://save', File.READ):
        OK:
            $CenterContainer/VBoxContainer/HighScoreLabel.text = (
                'High Score: ' + str(file.get_64()))
            file.close()
        ERR_FILE_NOT_FOUND:
            $CenterContainer/VBoxContainer/HighScoreLabel.queue_free()
        _:
            $CenterContainer/VBoxContainer/HighScoreLabel.queue_free()
            print('Error: unexpected error opening the save file in read mode')

func _on_StartButton_pressed():
    if get_tree().change_scene_to(game_scene) == OK:
        MenuMusicPlayer.stop()
    else:
        print('Error: could not switch to the game scene')
        get_tree().quit(1)

func _on_ExitButton_pressed():
    get_tree().quit()

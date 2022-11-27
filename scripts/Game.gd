class_name Game

extends Node2D

const GROUND_SPEED := 384.0
const TILE_SIZE := 64.0

export var cloud_scene: PackedScene
export var horse_scene: PackedScene

var score: int setget set_score
var mummies := 0

func _ready():
    VisualServer.set_default_clear_color(Color.skyblue)
    self.score = 0

func _process(delta: float):
    if not $MusicTimer.is_stopped():
        $MusicPlayer.volume_db = (
            lerp(-5.0, 0.0, $MusicTimer.time_left / $MusicTimer.wait_time))
        $MusicPlayer.pitch_scale = (
            lerp(0.75, 1.0, $MusicTimer.time_left / $MusicTimer.wait_time))

    $TextureRect.rect_position.x -= delta * GROUND_SPEED

    if -$TextureRect.rect_position.x > TILE_SIZE:
        $TextureRect.rect_position.x += TILE_SIZE

func _on_CloudTimer_timeout():
    $CloudTimer.wait_time = rand_range(3.0, 5.0)
    add_child(cloud_scene.instance())

func _on_HorseTimer_timeout():
    var horse: Horse = horse_scene.instance()

    if mummies > 0:
        horse.mummy = true
        mummies -= 1

    add_child(horse)

func _on_ScoreTimer_timeout():
    self.score += 1

func add_mummies():
    mummies += 5

func game_over():
    $ScoreTimer.stop()
    $CanvasLayer/CenterContainer.visible = true
    $FocusControl.grab_focus()
    $MusicTimer.start()

    var file := File.new()

    if file.open('user://save', File.READ_WRITE) == OK:
        var high_score := file.get_64()
        file.seek(0)

        if score > high_score:
            file.store_64(score)

        file.close()
    else:
        print('Error: could not open save file in write mode')



func _on_RestartButton_pressed():
    if get_tree().reload_current_scene() != OK:
        print('Error: could not restart the game scene')
        get_tree().quit(1)

func _on_ExitButton_pressed():
    if get_tree().change_scene('res://scenes/Menu.tscn') != OK:
        print('Error: could not switch to the menu scene')
        get_tree().quit(1)

func set_score(value):
    score = value
    $CanvasLayer/ScoreLabel.text = 'SCORE: ' + str(score)

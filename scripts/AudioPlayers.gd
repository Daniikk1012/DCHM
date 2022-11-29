extends Node

onready var playing := $MenuMusicPlayer

func _process(_delta: float):
    if not $SlowDownTimer.is_stopped():
        var progress = $SlowDownTimer.time_left / $SlowDownTimer.wait_time
        playing.volume_db = lerp(-5.0, 0.0, progress)
        playing.pitch_scale = lerp(0.75, 1.0, progress)

func stop_all():
    $MenuMusicPlayer.stop()
    $GameMusicPlayer.stop()
    $SlowDownTimer.stop()

func play():
    playing.volume_db = 0.0
    playing.pitch_scale = 1.0
    playing.play()

func play_menu():
    stop_all()
    playing = $MenuMusicPlayer
    play()

func play_game():
    stop_all()
    playing = $GameMusicPlayer
    play()

func slow_down():
    $SlowDownTimer.start()

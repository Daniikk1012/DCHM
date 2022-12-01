extends Node

onready var playing := $MenuMusicPlayer

var paused: AudioStreamPlayer
var game := true

func _process(_delta: float):
    if not $SlowDownTimer.is_stopped():
        var progress = $SlowDownTimer.time_left / $SlowDownTimer.wait_time
        playing.volume_db = lerp(-5.0, 0.0, progress)
        playing.pitch_scale = lerp(0.75, 1.0, progress)

func play():
    $SlowDownTimer.stop()
    playing.volume_db = 0.0
    playing.pitch_scale = 1.0
    playing.play()

func play_menu():
    game = false
    playing.stop()
    playing = $MenuMusicPlayer
    play()

func play_game():
    playing.stop()
    playing = $GameMusicPlayer
    play()

func play_deal(deal: bool):
    if deal:
        if paused == null:
            paused = playing
            playing.stream_paused = true
            playing = $DealMusicPlayer
            playing.play()
    else:
        if paused != null:
            playing.stop()
            playing = paused
            playing.stream_paused = false
            paused = null

func slow_down():
    $SlowDownTimer.start()

func _on_GameMusicPlayer_finished():
    if not game:
        game = true
        return

    if paused == null:
        playing.stop()
        playing = $LoopMusicPlayer
        playing.play()

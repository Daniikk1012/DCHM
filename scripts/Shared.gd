extends Node

const SCREEN_SIZE := Vector2(1920.0, 1080.0)
const PLAYER_SIZE := Vector2(64.0, 48.0)
const GROUND_SPEED := 384.0

var score: int
var music := 5 setget set_music
var sound := 5 setget set_sound

func _ready():
    var file := File.new()

    if file.open('user://save', File.READ) == OK:
        score = file.get_64()
        music = file.get_64()
        sound = file.get_64()
    else:
        push_error('Could not open save file for reading')

    file.close()

    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index('Music'), linear2db(music / 10.0))
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index('Sound'), linear2db(sound / 10.0))

func _on_Shared_tree_exiting():
    var file := File.new()

    if file.open('user://save', File.WRITE) == OK:
        file.store_64(score)
        file.store_64(music)
        file.store_64(sound)
    else:
        push_error('Could not open save file for writing')

    file.close()

func set_music(value: int):
    music = value
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index('Music'), linear2db(music / 10.0))

func set_sound(value: int):
    sound = value
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index('Sound'), linear2db(sound / 10.0))

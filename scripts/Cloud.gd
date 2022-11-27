extends Node2D

const SIZE := Vector2(128.0, 128.0)

onready var speed := rand_range(128.0, 256.0)

func _ready():
    position.x = Shared.SCREEN_SIZE.x + SIZE.x / 2.0
    position.y = rand_range(
        SIZE.y / 2.0,
        Shared.SCREEN_SIZE.y / 2.0 - SIZE.y / 2.0
    )

func _process(delta: float):
    position.x -= speed * delta

    if position.x + SIZE.x / 2.0 < 0.0:
        queue_free()

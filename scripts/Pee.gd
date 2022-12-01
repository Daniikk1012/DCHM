extends Area2D

var spawner: Horse

func _ready():
    position = spawner.position

func _physics_process(delta: float):
    position.x -= Shared.GROUND_SPEED * delta

    for horse in get_parent().get_children():
        if horse is Horse:
            if horse.overlaps_area(self) and horse != spawner:
                horse.speed = 256.0

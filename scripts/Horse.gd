class_name Horse

extends Area2D

const SIZE := Vector2(128.0, 64.0)

export var randomize_position := true

enum Type {
    HORSE,
    COW,
    MIMICK,
    DEVIL,
    MUMMY,
    TRUCK,
}

var mummy := false
var speed: float
var type: int
var touched := false

func _ready():
    ($CollisionShape2D.shape as RectangleShape2D).extents = SIZE / 2.0
    $Shadow.scale = SIZE / $Shadow.texture.get_size()

    if randomize_position:
        position.x = Shared.SCREEN_SIZE.x + SIZE.x / 2.0
        position.y = rand_range(
            Shared.SCREEN_SIZE.y / 2.0 + SIZE.y / 2.0,
            Shared.SCREEN_SIZE.y - SIZE.y / 2.0
        )
        speed = rand_range(64.0, 192.0)

        if not mummy:
            match randi() % 10:
                0, 1, 2, 3, 4:
                    type = Type.HORSE
                5:
                    type = Type.COW
                    $Icon.animation = 'cow'
                6, 7:
                    type = Type.MIMICK
                8:
                    type = Type.DEVIL
                    $Icon.animation = 'devil'
                9:
                    type = Type.TRUCK
                    $Icon.animation = 'truck'
        else:
            type = Type.MUMMY
            $Icon.animation = 'mummy'
    else:
        speed = 64.0
        type = Type.HORSE

func _process(_delta: float):
    if not $RemoveTimer.is_stopped():
        modulate.a = $RemoveTimer.time_left / $RemoveTimer.wait_time
    if $Icon.animation == 'none' and not $Particles2D.emitting:
        queue_free()

func _physics_process(delta: float):
    position.x -= delta * speed
    $Icon.z_index = position.y

    if position.x + SIZE.x / 2.0 + Shared.PLAYER_SIZE.x < 0.0:
        queue_free()

func touch():
    if not touched:
        touched = true

        match type:
            Type.MIMICK:
                $Icon.animation = 'mimick'
            Type.DEVIL:
                get_parent().add_mummies()
                get_parent().score += 50
            Type.MUMMY:
                $Icon.animation = 'sand'
            Type.TRUCK:
                $Icon.animation = 'tick'

func _on_Icon_animation_finished():
    if $Icon.animation == 'mimick' or $Icon.animation == 'sand':
        if type == Type.MIMICK:
            for body in get_overlapping_bodies():
                if body.has_method('die'):
                    body.die()
        $RemoveTimer.start()
    elif $Icon.animation == 'tick':
        for area in get_overlapping_areas():
            if area.get_class() == get_class():
                area.queue_free()

        for body in get_overlapping_areas():
            if body.has_method('die'):
                body.die()

        $Particles2D.emitting = true
        $Shadow.visible = false
        $Icon.visible = false

func _on_MimickTimer_timeout():
    queue_free()

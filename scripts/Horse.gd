class_name Horse

extends Area2D

const SIZE := Vector2(128.0, 64.0)

export var pee_scene: PackedScene
export var randomize_position := true

enum Type {
    HORSE,
    COW,
    MIMICK,
    DEVIL,
    MUMMY,
    TRUCK,
    BREAD,
    FIRE,
    PEE,
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
            match randi() % 20:
                0, 1, 2, 3, 4, 5, 6:
                    type = Type.HORSE
                7, 8, 9:
                    type = Type.COW
                    $Icon.animation = 'cow'
                10, 11:
                    type = Type.MIMICK
                12, 13:
                    type = Type.DEVIL
                    $Icon.animation = 'devil'
                14, 15:
                    type = Type.TRUCK
                    $Icon.animation = 'truck'
                16:
                    type = Type.BREAD
                    $Icon.animation = 'bread'
                17, 18:
                    type = Type.FIRE
                    $Icon.animation = 'fire'
                    $FireParticles.emitting = true
                19:
                    type = Type.PEE
                    $Icon.animation = 'pants'
        else:
            type = Type.MUMMY
            $Icon.animation = 'mummy'
    else:
        speed = 64.0
        type = Type.HORSE

func _process(_delta: float):
    if not $RemoveTimer.is_stopped():
        modulate.a = $RemoveTimer.time_left / $RemoveTimer.wait_time

    if not $Icon.visible and not $ExplosionParticles.emitting:
        queue_free()

func _physics_process(delta: float):
    position.x -= delta * speed
    $Icon.z_index = position.y
    $FireParticles.z_index = $Icon.z_index

    if position.x + SIZE.x / 2.0 + Shared.PLAYER_SIZE.x < 0.0:
        queue_free()

func touch(player: Node):
    if not touched:
        touched = true

        match type:
            Type.COW:
                $CowSoundPlayer.play()
            Type.MIMICK:
                $Icon.animation = 'mimick'
            Type.DEVIL:
                $DevilSoundPlayer.play()
                get_parent().add_mummies()
                get_parent().score += 50
            Type.MUMMY:
                $Icon.animation = 'sand'
            Type.TRUCK:
                $Icon.animation = 'tick'
            Type.BREAD:
                $BreadSoundPlayer.play()
                get_parent().score += 10
            Type.PEE:
                if $Icon.animation == 'pants':
                    $Icon.animation = 'pee'

    if type == Type.FIRE:
        player.fire()

func _on_Icon_animation_finished():
    if $Icon.animation == 'mimick' or $Icon.animation == 'sand':
        if type == Type.MIMICK:
            $MimickSoundPlayer.play()

            for body in get_overlapping_bodies():
                if body.has_method('die'):
                    body.die()

        $RemoveTimer.start()
    elif $Icon.animation == 'tick':
        $TruckSoundPlayer.play()

        for area in get_overlapping_areas():
            if area.get_class() == get_class():
                area.queue_free()

        for body in get_overlapping_bodies():
            if body.has_method('die'):
                body.die()

        $ExplosionParticles.emitting = true
        $Shadow.visible = false
        $Icon.visible = false
    elif $Icon.animation == 'pee':
        $Icon.animation = 'peed'
        var pee: Node2D = pee_scene.instance()
        pee.spawner = self
        get_parent().add_child(pee)

func _on_MimickTimer_timeout():
    queue_free()

func overlaps_body(body: Node) -> bool:
    return $RemoveTimer.is_stopped() and $Icon.visible and .overlaps_body(body)

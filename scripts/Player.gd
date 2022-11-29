class_name Player

extends KinematicBody2D

const SIZE := Shared.PLAYER_SIZE
const SPEED_X := 1024.0
const SPEED_Y := 512.0
const THRESHOLD := 0.5
const JUMP_IMPULSE := 512.0
const GRAVITY := 1024.0
const HORSE_HEIGHT := 48.0

var vertical_position := 0.0
var vertical_speed := 0.0
var alive = true

func _ready():
    ($CollisionShape2D.shape as RectangleShape2D).extents = SIZE / 2.0

func _process(_delta: float):
    if alive:
        if (Input.is_action_just_pressed('jump')
            and vertical_speed == 0.0
            and vertical_position <= HORSE_HEIGHT
        ):
            vertical_speed = JUMP_IMPULSE

func _physics_process(delta: float):
    vertical_speed -= delta * GRAVITY
    vertical_position += delta * vertical_speed

    if alive:
        var found: Horse = null

        if vertical_position < HORSE_HEIGHT:
            for horse in get_parent().get_children():
                if horse is Horse:
                    if horse.overlaps_body(self):
                        found = horse
                        found.touch(self)

        var direction = Vector2(
            (Input.get_action_strength('right')
                - Input.get_action_strength('left')),
            (Input.get_action_strength('down')
                - Input.get_action_strength('up'))
        )

        if found != null:
            vertical_position = HORSE_HEIGHT
            vertical_speed = 0.0
            position.x -= found.speed * delta

        if direction.length_squared() > THRESHOLD * THRESHOLD:
            var _velocity = (
                move_and_slide(direction * Vector2(SPEED_X, SPEED_Y)))

        if vertical_position < 0.0 or position.x + SIZE.x / 2.0 < 0.0:
            die()

    else:
        position.x -= Game.GROUND_SPEED * delta

        if vertical_position < 0.0:
            vertical_speed = 0.0
            vertical_position = 0.0

    $IconContainer/Icon.position.y = -vertical_position

    if vertical_position >= HORSE_HEIGHT:
        $IconContainer/Icon.z_index = Shared.SCREEN_SIZE.y
    else:
        $IconContainer/Icon.z_index = position.y

func fire():
    if $FireTimer.is_stopped():
        $FireTimer.start()

    $ExtinguishTimer.start()
    $IconContainer/Icon/FireParticles.emitting = true

func _on_FireTimer_timeout():
    die()

func _on_ExtinguishTimer_timeout():
    $FireTimer.stop()
    $IconContainer/Icon/FireParticles.emitting = false

func die():
    vertical_speed = 0.0
    alive = false
    (get_parent() as Game).game_over()

extends Area2D

signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _on_body_entered(body):
	emit_signal("hit")
	
	hide()  # Player disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)
	# ^ Disabling the area’s collision shape can cause an error if it happens
	# in the middle of the engine’s collision processing; hence the `deferred`.

func _process(delta):
	var velocity = _get_velocity()
	_update_position(velocity, delta)
	_update_animation(velocity)

func _get_velocity():
	var velocity = Vector2()  # The player's movement vector.
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	return velocity.normalized() * speed

func _update_position(velocity, delta):
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _update_animation(velocity):
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

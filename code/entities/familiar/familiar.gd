extends CharacterBody3D

class_name Familiar

var input_dir : Vector2
var direction : Vector3
var last_direction := Vector3(0,0,1)
var can_roll := true
var is_rolling := false

@export var speed := 14
@export var rollspeed := 20
@onready var pivot := $Pivot
@onready var rollcooldown := $Roll/RollCooldown
@onready var hurtbox := $HurtBox/HurtBoxCollision
@onready var attack := $Pivot/Attack
@onready var health := $Health
@onready var sprite := $Pivot/Sprite3D
@onready var animation_player := $Pivot/Attack/HitBox/AttackAnimation

func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor() and !is_rolling:
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if last_direction.x > 0:
		sprite.flip_h = true
	else: 
		sprite.flip_h = false
	if !global_transform.origin.is_equal_approx(global_position - direction):
		pivot.look_at(global_position - direction, Vector3.UP)
	if Input.is_action_just_pressed("roll"):
		roll(delta)
	elif is_rolling:
		velocity.x = last_direction.x * rollspeed * delta
		velocity.z = last_direction.z * rollspeed * delta
	elif direction and !is_rolling:
		sprite.play("run")
		last_direction = direction
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	elif attack.is_attacking:
		animation_player.play("BaseAttack")
	else:
		sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if Input.is_action_just_pressed("attack"):
		attack.attack("BaseAttack")
	move_and_slide()

func _on_roll_timer_timeout():
	set_collision_mask_value(3, true)
	_set_is_rolling(false)
	rollcooldown.start()
	hurtbox.set_disabled(false)

func roll(delta):
	if _get_can_roll():
		set_collision_mask_value(3, false)
		_set_is_rolling(true)
		hurtbox.set_disabled(true)
		_set_can_roll(false)
		sprite.play("roll")
	else:
		pass

func _on_roll_cooldown_timeout():
	_set_can_roll(true)

func _get_can_roll() -> bool:
	return can_roll

func _set_can_roll(value : bool) -> void:
	can_roll = value

func _get_is_rolling() -> bool:
	return is_rolling

func _set_is_rolling(value : bool) -> void:
	is_rolling = value

func _on_died():
	print("GAME OVER")

func _on_attack_damage(body : Node3D, damage : int):
	#print(body)
	if body.is_in_group("Enemy"):
		#print(body)
		body.health.take_damage(damage)

func _on_health_damaged(new_health):
	print(new_health)

func _on_sprite_3d_animation_finished():
	if is_rolling:
		_on_roll_timer_timeout()

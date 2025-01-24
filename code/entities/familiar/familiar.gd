extends CharacterBody3D

var input_dir : Vector2
var direction : Vector3
var last_direction := Vector3(0,0,1)
var can_attack : bool

@export var speed := 14
@export var rollspeed := 20
@onready var rolltimer := $RollTimer
@onready var rollcooldown := $RollCooldown
@onready var hurtbox := $HurtBox/HurtBoxCollision
@onready var hitbox := $HitBox
@onready var clawattack := $HitBox/ClawAttack
@onready var attacktimer := $AttackTimer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_just_pressed("roll"):
		roll()
	elif direction and rolltimer.is_stopped():
		last_direction = direction
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.is_action_just_pressed("attack"):
		attack()
	move_and_slide()

func _on_roll_timer_timeout():
	rollcooldown.start()
	hurtbox.set_disabled(false)

func _on_hit_box_body_entered(body):
	print(body)

func roll():
	if rollcooldown.is_stopped():
		velocity.x = last_direction.x * rollspeed
		velocity.z = last_direction.z * rollspeed
		hurtbox.set_disabled(true)
		rolltimer.start()
	else:
		pass

func attack():
	hitbox.set_monitoring(true)
	_set_can_attack(false)
	clawattack.play("ClawAttack")
	attacktimer.start()

func _on_attack_timer_timeout():
	_set_can_attack(true)

func _get_can_attack() -> bool:
	return can_attack

func _set_can_attack(value : bool) -> void:
	can_attack = value

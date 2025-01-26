extends CharacterBody3D

class_name Enemy

@export var speed = 10
@onready var player := $"../Familiar"
@onready var attack := $Attack
@onready var aggroradius := $AggroRadius
@onready var health := $Health

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Enemy tracks player movement. If you get above the enemy it can only move towards the camera though...
	var vector := self.global_position.direction_to(player.global_position)
	var direction = (Vector3(vector.x, 0, vector.z)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if player in aggroradius.get_overlapping_bodies():
		attack.attack()
	move_and_slide()

func _on_died():
	queue_free()

func _on_attack_damage(body : Node3D, damage : int):
	if body.is_in_group("Player"):
		print(body)
		body.health.take_damage(damage)

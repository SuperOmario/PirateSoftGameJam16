extends CharacterBody3D

class_name Enemy

@export var speed = 10
@onready var pivot := $Pivot
@onready var player := $"../Familiar"
@onready var attack := $Pivot/Attack
@onready var aggroradius := $AggroRadius
@onready var health := $Health

func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta

	# Enemy tracks player movement. If you get above the enemy it can only move towards the camera though...
	var vector := self.global_position.direction_to(player.global_position)
	var direction = (Vector3(vector.x, 0, vector.z)).normalized()
	pivot.look_at(global_position + player.global_position, Vector3.UP)
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if player in aggroradius.get_overlapping_bodies():
		attack.attack("BaseAttack")
	move_and_slide()

func _on_died():
	queue_free()

func _on_attack_damage(body : Node3D, damage : int):
	if body.is_in_group("Player"):
		print(body)
		body.health.take_damage(damage)

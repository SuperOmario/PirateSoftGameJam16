extends Node

class_name Attack

signal damage
var can_attack := true
var is_attacking := false
@export var attackdamage := 10
@export var attacktimertime := 0.2
@export var attackcooldowntime := 0.1
@onready var hitbox := $HitBox
@onready var attackanimation := $HitBox/AttackAnimation
@onready var attacktimer := $AttackTimer
@onready var attackcooldown := $AttackCooldown

func attack(attack_name):
	if can_attack:
		hitbox.set_monitoring(true)
		_set_can_attack(false)
		_set_is_attacking(true)
		attackanimation.play(attack_name)
		attacktimer.start()

func _on_attack_timer_timeout():
	_set_is_attacking(false)
	attackcooldown.start()
	hitbox.set_monitoring(false)

func _on_attack_cooldown_timeout():
	_set_can_attack(true)

func _get_can_attack() -> bool:
	return can_attack

func _set_can_attack(value : bool) -> void:
	can_attack = value

func _get_is_attacking() -> bool:
	return is_attacking

func _set_is_attacking(value : bool) -> void:
	is_attacking = value

func _on_hit_box_body_entered(body):
	print(body)
	emit_signal("damage", body, attackdamage)

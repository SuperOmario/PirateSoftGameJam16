extends Node

signal damage
var can_attack := true
@export var attackdamage := 10
@export var attacktimertime := 0.2
@export var attackcooldowntime := 0.1
@onready var hitbox := $HitBox
@onready var attackanimation := $HitBox/AttackAnimation
@onready var attacktimer := $AttackTimer
@onready var attackcooldown := $AttackCooldown

func attack():
	if can_attack:
		hitbox.set_monitoring(true)
		_set_can_attack(false)
		attackanimation.play("ClawAttack")
		attacktimer.start()

func _on_attack_timer_timeout():
	attackcooldown.start()
	hitbox.set_monitoring(false)

func _on_attack_cooldown_timeout():
	_set_can_attack(true)

func _get_can_attack() -> bool:
	return can_attack

func _set_can_attack(value : bool) -> void:
	can_attack = value

func _on_hit_box_body_entered(body):
	print(body)
	emit_signal("damage", body, attackdamage)

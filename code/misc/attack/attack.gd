extends Node

signal damage
var can_attack := true
@export var enemy_group : String
@export var attackdamage := 1
@onready var hitbox := $HitBox
@onready var attackanimation := $HitBox/AttackAnimation
@onready var attacktimer := $AttackTimer
@onready var attackcooldown := $AttackCooldown

func attack():
	print("attacking")
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
	if body.is_in_group(enemy_group):
		emit_signal("damage", attackdamage)

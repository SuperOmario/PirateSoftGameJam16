extends Enemy

@onready var camera := $"../Familiar/Camera/Camera3D"
@onready var attack_animation := $Pivot/Attack/HitBox/AttackAnimation
@onready var sprite_body := $Pivot/Sprite3D
@onready var sprite_tongue := $Pivot/Sprite3D/AnimatedSprite3D

func _process(delta):
	$Pivot/Sprite3D.look_at(camera.global_transform.origin, Vector3.UP)
	if !attack.is_attacking:
		attack_animation.play("Hop")
		
	if velocity.x < 0:
		sprite_tongue.position.x = 1.9
		sprite_body.flip_h = true
		sprite_tongue.flip_h = true
	else:
		sprite_tongue.position.x = -1.9
		sprite_body.flip_h = false
		sprite_tongue.flip_h = false

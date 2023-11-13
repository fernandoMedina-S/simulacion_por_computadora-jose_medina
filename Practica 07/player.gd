extends CharacterBody2D

var movement_speed = 200.0
var hp = 80
var spear = preload("res://Weapons/spear.tscn")

@onready var spearTimer = get_node("%SpearTimer")
@onready var spearAttackTimer = get_node("%SpearAttackTimer")

var spear_ammo = 0
var spear_base_ammo = 1
var spear_attack_speed = 1.5
var spear_level = 1

var enemy_close = []

@onready var sprite = $Sprite2D

func _ready():
	attack()

func _physics_process(delta):
	movement()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	velocity = mov.normalized()*movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)

func attack():
	if spear_level > 0:
		spearTimer.wait_time = spear_attack_speed
		if spearTimer.is_stopped():
			spearTimer.start()

func _on_spear_timer_timeout():
	spear_ammo += spear_base_ammo
	spearAttackTimer.start()


func _on_spear_attack_timer_timeout():
	if spear_ammo > 0:
		var spear_attack = spear.instantiate()
		spear_attack.position = global_position
		spear_attack.target = get_random_target()
		spear_attack.level = spear_level
		add_child(spear_attack)
		spear_ammo -= 1
		if spear_ammo > 0:
			spearAttackTimer.start()
		else:
			spearAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

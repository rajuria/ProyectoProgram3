extends CharacterBody2D

var Speed = 140
var LastDirection = Vector2.ZERO
var AnimatedSprite
var EnemyInRange=false
var Health = 150
var Attacking=false
var AttackTimer=0.0
var AttackDuration=0.2
var KnockBack = 1

func _ready():
	AnimatedSprite = $AnimatedSprite2D
	add_to_group("Player")

func _physics_process(delta):
	UpdateHealth()
	Die()
	UpdateAnimation()
	move_and_slide()
	if Attacking:
		AttackTimer+=delta
		velocity=Vector2.ZERO
	if AttackTimer>=AttackDuration:
		Attacking=false
		AttackTimer=0.0
	
func UpdateAnimation():
	if Global.LinkIsDead:
		velocity=Vector2.ZERO
		return
	if Global.PlaySwordAnimation:
		velocity=Vector2.ZERO
		return
	
	if Attacking:
		if LastDirection.y<0:
			AnimatedSprite.play("AttackUp")
		elif LastDirection.y>0:
			AnimatedSprite.play("AttackDown")
		elif LastDirection.x !=0:
			AnimatedSprite.play("AttackRight")
		return
	var Direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = Direction*Speed
	
	if Direction != Vector2.ZERO:
		LastDirection=Direction
	
	if Direction.x!=0:
		AnimatedSprite.play("WalkRight")
	elif Direction.y <0:
		AnimatedSprite.play("WalkUp")
	elif Direction.y >0:
		AnimatedSprite.play("WalkDown")
	else:
		if LastDirection.x !=0:
			AnimatedSprite.play("IdleRight")
		elif LastDirection.y <0:
			AnimatedSprite.play("IdleUp")
		elif LastDirection.y >0:
			AnimatedSprite.play("IdleDown")
	AnimatedSprite.flip_h = LastDirection.x >0

func _input(event):
	if event.is_action_pressed("ui_select") and Global.LinkHasSword:
		Attacking=true
		AttackTimer=0.0
		$AttackSound.play()
	if event.is_action_pressed("ui_cancel"):
		Health=0
	
func UpdateHealth():
	var HealthBar = $HealthBar
	HealthBar.value = Health
	if Health>=150:
		HealthBar.visible = false
	else:
		HealthBar.visible = true

func Die():
	if Health<=0 and not Global.LinkIsDead:
		Global.LinkIsDead=true
		Global.LastOverworldPosition= position
		AnimatedSprite.play("Death")
		$Death.play()


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		EnemyInRange=true



func _on_hitbox_body_exited(body):
	if body.is_in_group("Enemy"):
		EnemyInRange=false


func _on_animated_sprite_2d_animation_finished():
	if AnimatedSprite.animation=="Death":
		get_tree().change_scene_to_file("res://game_over.tscn")

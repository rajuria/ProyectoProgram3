extends CharacterBody2D

var Speed=20
var AttackSpeed = 50
var LastDirection=Vector2.ZERO
var AnimatedSprite
var DirectionChangeTimer=0
var DirectionChangeInterval =3 #Seconds!
var MinPosition = Vector2(120,120) #Boundaries
var MaxPosition = Vector2(500,300)
var Attacking = false
var Player = null
var PlayerInRange = false
var Health = 300
var Dead = false
var DamageTimer=0.0
var DamageInterval=0.5
var DamageFromPlayerTimer=0.0
var DamagefromPlayerInterval=0.1
var EnemyKnockBack=2
var Weakened=false


func _ready():
	AnimatedSprite=$AnimatedSprite2D
	PickRandomDirection()
	add_to_group("Boss")
	
func _physics_process(delta):
	if Dead:
		position-=Vector2(0,0.1)
		return
	if Weakened:
		velocity=Vector2(0,0)
		UpdateHealth()
		Die()
		if PlayerInRange and Player.Attacking:
			DamageFromPlayerTimer+=delta
		if DamageFromPlayerTimer>=DamagefromPlayerInterval and Player.Attacking:
			Health-=10
			KnockBack(Player.LastDirection)
			$Hurt.play()
			DamageFromPlayerTimer=0.0
		return
	UpdateHealth()
	Die()
	if Attacking and not Global.LinkIsDead:
		var DirectionToPlayer=(Player.position-position).normalized()
		velocity = DirectionToPlayer*AttackSpeed
		UpdateAnimation(DirectionToPlayer)
	else:
		DirectionChangeTimer+=delta #delta is the number of seconds
		if DirectionChangeTimer>=DirectionChangeInterval:
			PickRandomDirection()
			DirectionChangeTimer=0
		velocity = LastDirection*Speed
		UpdateAnimation(LastDirection)
	move_and_slide()
	
	var OldPosition = position
	position.x = clamp(position.x,MinPosition.x,MaxPosition.x)
	position.y= clamp(position.y,MinPosition.y,MaxPosition.y)
	
	if OldPosition != position:
		LastDirection=-LastDirection
	if PlayerInRange:
		DamageTimer+=delta
	if DamageTimer>=DamageInterval and not Weakened:
		AnimatedSprite.play("Attacking")
		$HA.play()
		DamageTimer=0.0
		
func UpdateAnimation(Direction):
	pass
		#AnimatedSprite.flip_h=Direction.x<0
		
func KnockBack(Direction):
	if Direction.x>0:
		position.x+=0*Player.KnockBack
	elif Direction.x<0:
		position.x-=0*Player.KnockBack
	elif Direction.y>0:
		position.y+=0*Player.KnockBack
	elif Direction.y<0:
		position.y-=0*Player.KnockBack
func PlayerKnockBack(Direction):
	if Direction.x>0:
		Player.position.x+=20*EnemyKnockBack
	elif Direction.x<0:
		Player.position.x-=20*EnemyKnockBack
	elif Direction.y>0:
		Player.position.y+=20*EnemyKnockBack
	elif Direction.y<0:
		Player.position.y-=20*EnemyKnockBack

func PickRandomDirection():
	var NewDirection = Vector2.ZERO
	while NewDirection==Vector2.ZERO:
		NewDirection = Vector2(randi()%3-1, randi()%3-1)
		NewDirection=NewDirection.normalized()
		LastDirection=NewDirection

func Hurt():
	$Hit.play()
	AnimatedSprite.play("Hurt")
	Weakened= true
	

func UpdateHealth():
	var HealthBar=$HealthBar
	HealthBar.value=Health
	if Health>=300:
		HealthBar.visible=false
	else:
		HealthBar.visible=true
		
func Die():
	if Health<=0 and not Dead:
		AnimatedSprite.play("Death")
		$Die.play()
		Dead=true
		#queue_free()

func _on_animated_sprite_2d_animation_finished():
	if AnimatedSprite.animation=="Death":
		queue_free()
	if AnimatedSprite.animation=="Attacking":
		Player.Health-=20
		$PlayerHit.play()
		AnimatedSprite.play("Idle")
		position-=Vector2(0,5)
	if AnimatedSprite.animation=="Hurt":
		Weakened= false
		AnimatedSprite.play("Idle")

func _on_phamtom_ganon_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		PlayerInRange=true
		AttackSpeed=0


func _on_phamtom_ganon_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		PlayerInRange=false
		AttackSpeed=60


func _on_territory_body_entered(body):
	if body.is_in_group("Player"):
		Player=body
		Attacking=true


func _on_territory_body_exited(body):
	if body.is_in_group("Player"):
		Player=null
		Attacking=false
		PickRandomDirection()
		UpdateAnimation(LastDirection)

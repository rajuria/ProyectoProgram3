extends CharacterBody2D

var Speed=50
var AttackSpeed = 150
var LastDirection=Vector2.ZERO
var AnimatedSprite
var DirectionChangeTimer=0
var DirectionChangeInterval =3 #Seconds!
var Attacking = false
var Player = null
var PlayerInRange = false
var Health = 75
var Dead = false
var DamageTimer=0.0
var DamageInterval=0.5
var DamageFromPlayerTimer=0.0
var DamagefromPlayerInterval=0.1
var EnemyKnockBack=0


func _ready():
	AnimatedSprite=$AnimatedSprite2D
	PickRandomDirection()
	add_to_group("Enemy")
	
func _physics_process(delta):
	if Dead:
		AnimatedSprite.play("Death")
		return
	if PlayerInRange and Player.Attacking:
		DamageFromPlayerTimer+=delta
	if DamageFromPlayerTimer>=DamagefromPlayerInterval and Player.Attacking:
		#Health-=25
		KnockBack(Player.LastDirection)
		$Hit.play()
		DamageFromPlayerTimer=0.0
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
	
	if PlayerInRange:
		DamageTimer+=delta
	if DamageTimer>=DamageInterval:
		var Multiplier
		if(Global.LinkHasSword):
			Multiplier=1
		else:
			Multiplier=100
		Player.Health-=(10*Multiplier)
		$PlayerHit.play()
		DamageTimer=0.0
		PlayerKnockBack(LastDirection)
		
func UpdateAnimation(Direction):
	if Direction.x !=0:
		AnimatedSprite.play("WalkingRight")
		AnimatedSprite.flip_h=Direction.x>0
	elif Direction.y<0:
		AnimatedSprite.play("WalkingUp")
	elif Direction.y>0:
		AnimatedSprite.play("WalkingDown")
		
func KnockBack(Direction):
	if Direction.x>0:
		position.x+=20*Player.KnockBack
	elif Direction.x<0:
		position.x-=20*Player.KnockBack
	elif Direction.y>0:
		position.y+=20*Player.KnockBack
	elif Direction.y<0:
		position.y-=20*Player.KnockBack
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

func UpdateHealth():
	var HealthBar=$HealthBar
	HealthBar.value=Health
	if Health>=50:
		HealthBar.visible=false
	else:
		HealthBar.visible=true
		
func Die():
	if Health<=0 and not Dead:
		$Death.play()
		Dead=true
		#queue_free()



func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		PlayerInRange=true
		AttackSpeed=0

func _on_hitbox_body_exited(body):
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


func _on_animated_sprite_2d_animation_finished():
	if AnimatedSprite.animation=="Death":
		queue_free()

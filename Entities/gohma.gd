extends CharacterBody2D

var Speed=70
var AttackSpeed = 100
var LastDirection=Vector2.ZERO
var AnimatedSprite
var DirectionChangeTimer=0
var DirectionChangeInterval =3 #Seconds!
var MinPosition = Vector2(10,10) #Boundaries
var MaxPosition = Vector2(375,550)
var Attacking = false
var Player = null
var PlayerInRange = false
var Health = 50
var Dead = false
var DamageTimer=0.0
var DamageInterval=0.5
var DamageFromPlayerTimer=0.0
var DamagefromPlayerInterval=0.2


func _ready():
	AnimatedSprite=$AnimatedSprite2D
	PickRandomDirection()
	add_to_group("Enemy")
	
func _physics_process(delta):
	if PlayerInRange and Player.Attacking:
		DamageFromPlayerTimer+=delta
	if DamageFromPlayerTimer>=DamagefromPlayerInterval and Player.Attacking:
		Health-=10
		print("Gohma Health: ",Health)
		DamageFromPlayerTimer=0.0
	UpdateHealth()
	Die()
	if Attacking:
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
	if DamageTimer>=DamageInterval:
		Player.Health-=10
		DamageTimer=0.0
		
func UpdateAnimation(Direction):
	if Direction.x !=0:
		AnimatedSprite.play("WalkingRight")
		AnimatedSprite.flip_h=Direction.x<0
	elif Direction.y<0:
		AnimatedSprite.play("WalkingUp")
	elif Direction.y>0:
		AnimatedSprite.play("WalkingDown")

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
		Dead=true
		queue_free()


func _on_gohma_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		PlayerInRange=true
		AttackSpeed=0

func _on_gohma_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		PlayerInRange=false
		AttackSpeed=60

func _on_gohma_territory_body_entered(body):
	if body.is_in_group("Player"):
		Player=body
		Attacking=true

func _on_gohma_territory_body_exited(body):
	if body.is_in_group("Player"):
		Player=null
		Attacking=false
		PickRandomDirection()
		UpdateAnimation(LastDirection)

extends CharacterBody2D

var Speed=70
var LastDirection=Vector2.ZERO
var AnimatedSprite
var DirectionChangeTimer=0
var DirectionChangeInterval =3 #Seconds!


func _ready():
	AnimatedSprite=$AnimatedSprite2D
	PickRandomDirection()

func _physics_process(delta):
	DirectionChangeTimer+=delta #delta is the number of seconds
	if DirectionChangeTimer>=DirectionChangeInterval:
		PickRandomDirection()
		DirectionChangeTimer=0
	velocity = LastDirection*Speed
	UpdateAnimation(LastDirection)
	move_and_slide()

func UpdateAnimation(Direction):
	AnimatedSprite.flip_h=Direction.x<0
	
func PickRandomDirection():
	var NewDirection = Vector2.ZERO
	while NewDirection==Vector2.ZERO:
		NewDirection = Vector2(randi()%3-1, randi()%3-1)
		NewDirection=NewDirection.normalized()
		LastDirection=NewDirection

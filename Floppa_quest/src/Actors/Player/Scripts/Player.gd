extends Actor

var playerHP = 6
var fantaCount = 0
var playerInvulnerable = false

#this method runs every frame to render the game's physics
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_pressed("up") and !is_on_floor()
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	calculate_enemy_collision()
	if Input.is_action_just_pressed("left click"):
		player_attack()

#gets direction based off of player input
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0 if Input.is_action_just_pressed("up") and is_on_floor() else 1.0
	)

#takes three arguments _velocity, direction, and speed to calculate player movement
func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, 
speed: Vector2, is_jump_interrupted: bool) -> Vector2:
	var jumpCounter = 0;
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted and jumpCounter < 1:
		new_velocity.y = speed.y * direction.y*-1
	return new_velocity

#function called in the physics process to run all the processes that
#occur when a player collides with the enemy
func calculate_enemy_collision():
	var collision = get_last_slide_collision()
	if collision == null:
		return
	if collision.collider is KinematicBody2D && !playerInvulnerable:
		playerHP -= 1
		on_hit_player_invincibility(1)
		#print("player collided with enemy")
	get_node("HP_Label").text = "Current HP: " + str(playerHP)

#gives the player kinematic body brief immunity to hp loss after a collision
#and plays an animation to indicate this state to the player
func on_hit_player_invincibility(delay_time: float) -> void:
	playerInvulnerable = true
	get_node("Damage Sound").play()
	for n in 5:
		get_node("FloppaSprite").frame = 1
		yield(get_tree().create_timer(delay_time/10), "timeout")
		get_node("FloppaSprite").frame = 2
		yield(get_tree().create_timer(delay_time/10), "timeout")
	get_node("FloppaSprite").frame = 0
	yield(get_tree().create_timer(delay_time), "timeout")
	playerInvulnerable = false
#method for handling the player attack
#TODO: finish this function

func player_attack():
	var slash = get_node("SlashSprite")
	slash.visible = true
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - self.position).normalized()
	#calculate new angle for attack sprite
	var new_angle =  2*PI + atan2(direction.y, direction.x)
	#calculate new position for the attack sprite
	slash.position = Vector2(100*cos(new_angle), 100*sin(new_angle))
	slash.rotation  = new_angle
	get_node("Sword Slash").play()
	get_node("SlashSprite/SlashArea").monitoring = true
	get_node("SlashSprite/SlashArea").monitorable = true
	slash.play()
	slash.frame = 0
	get_node("SlashSprite/SlashArea").monitoring = false
	get_node("SlashSprite/SlashArea").monitorable = false
	
func on_CollectableArea2D_body_entered(body):
	fantaCount += 1



func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene("res://src/Levels/TestLevel.tscn")

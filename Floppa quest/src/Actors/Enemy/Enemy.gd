extends "res://src/Actors/Player/Scripts/Actor.gd"
class_name Enemy
var direction = Vector2(-1,0)
var enemySpeed = Vector2(100, 10)
var facing_direction
var enemy_velocity = Vector2(enemySpeed.x * direction.x, 0)
var HP = 3

func _physics_process(delta: float) -> void:
	enemy_velocity = calculate_velocity(enemy_velocity, direction)
	enemy_velocity = move_and_slide(enemy_velocity, FLOOR_NORMAL)
	#uses a 2d raycast to allow enemies to path on pathforms
	if is_on_wall() or (is_on_floor() and !get_node("BingusEdited/RayCast2D").is_colliding()):
		direction.x *= -1
		get_node("BingusEdited/RayCast2D").position.x *= -1.0
		update_facing_direction("BingusEdited")

func calculate_velocity(velocity: Vector2, direction: Vector2) -> Vector2:
	var new_velocity = velocity
	new_velocity.x = enemySpeed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	return new_velocity

func update_facing_direction(nodeName: String):
	if(direction.x < 0):
		get_node(nodeName).set_flip_h(true)
	if(direction.x > 0):
		get_node(nodeName).set_flip_h(false)
	
func take_damage(numDamage: int):
	get_node("DeathSound").play()
	get_node("BingusEdited").frame = 1
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("BingusEdited").frame = 0
	HP -= numDamage
	if HP <= 0:
		queue_free()



func _on_EnemyArea2D_area_entered(area):
	if area.is_in_group("hitbox"):
		take_damage(1)

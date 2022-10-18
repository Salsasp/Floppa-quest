extends Node2D

var num_collected = 0




func _on_CollectableArea2D_body_entered(body):
	if body.is_in_group("player"):
		print("success")
		get_node("PickupSound").play()


#debug: can trigger coin pickup sound infinitely
func _on_PickupSound_finished():
	queue_free()

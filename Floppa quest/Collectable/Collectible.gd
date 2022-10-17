extends Node2D

var num_collected = 0


func _on_Area2D_body_entered(area):
	print("2d area entered")
	if area.is_in_group("player"):
		get_node("PickupSound").play()
		queue_free()

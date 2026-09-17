extends Node2D


func _ready() -> void:
	#var obj = $reference_nodes/obstacles/obj1.duplicate()
	##obj.position = $reference_nodes/obstacles/obj1.position
	#$moving_nodes/obstacles.add_child(obj)
	#
	#await get_tree().create_timer(3.0).timeout
	##var obj2 = $reference_nodes/obstacles/obj1.duplicate()
	##print($reference_nodes/obstacles/obj1.global_position, " $reference_nodes/obstacles/obj1.global_position")
	##print(obj.global_position, " obj.global_position")
	#
	#obj = $reference_nodes/obstacles/obj1.duplicate()
	##obj.position = $reference_nodes/obstacles/obj1.position
	#$moving_nodes/obstacles.add_child(obj)
	#$reference_nodes/obstacles.get_children()
	
	spawn()
	pass

func spawn():
	var temp = randi_range($reference_nodes/obstacles.get_child_count()-1, 0)
	var obj = $reference_nodes/obstacles.get_child(temp).duplicate()
	$moving_nodes/obstacles.add_child(obj)
	
	await get_tree().create_timer(2.5).timeout
	spawn()

func _process(delta: float) -> void:
	#$moving_nodes.position.x -= 1
	for i in $moving_nodes/obstacles.get_children():
		i.position.x -= 240 * delta
		#print($moving_nodes/obstacles.get_children())
	
	pass

func _on_obstacle_body_entered(body: Node2D) -> void:
	if body == $player:
		print("dead")

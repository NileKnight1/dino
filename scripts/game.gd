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
	spawn_obstacles()
	spawn_powers()

func spawn_powers():
	#print("power spawned")
	var temp = randi_range($reference_nodes/powers.get_child_count()-1, 0)
	var obj = $reference_nodes/powers.get_child(temp).duplicate()
	$moving_nodes/powers.add_child(obj)
	
	await get_tree().create_timer(wait_time).timeout
	print("spawn")
	spawn_powers()


func spawn_obstacles():
	#print("obstacle spawned")
	var temp = randi_range($reference_nodes/obstacles.get_child_count()-1, 0)
	var obj = $reference_nodes/obstacles.get_child(temp).duplicate()
	$moving_nodes/obstacles.add_child(obj)
	
	#print(520/speed)
	await get_tree().create_timer(wait_time*5/4).timeout
	spawn_obstacles()

var wait_time = 2
var speed = 240
func _process(delta: float) -> void:
	#$moving_nodes.position.x -= 1
	for i in $moving_nodes/obstacles.get_children():
		i.position.x -= speed * delta
	for i in $moving_nodes/powers.get_children():
		i.position.x -= speed * delta
	
		#print($moving_nodes/obstacles.get_children())
	
	pass

func _on_obstacle_body_entered(body: Node2D) -> void:
	if body == $player:
		if player_shield: 
			print("safed")
			return
		print("dead")

var player_shield = 0
var player_rushing = 0

func _on_sheild_taken(body: Node2D) -> void:
	if body == $player:
		player_shield = 1
func _on_rush_taken(body: Node2D) -> void:
	if body == $player:
		print("rush")
		player_rushing = 1
		player_shield = 1
		speed = 1000
		wait_time= 0.5
		await get_tree().create_timer(3.0).timeout
		#wait_time= 2
		#player_rushing = 0
		#player_shield = 0
		#

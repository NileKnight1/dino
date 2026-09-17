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
	
	$CanvasLayer/restart.visible = 0
	$player.game = self
	spawn()
	score_inc()
	difficulty()

var def_speed
var def_wait_time

func spawn():
	spawn_obstacles()
	spawn_powers()
	spawn_coins()

func spawn_coins():
	if stop_game: return
	#print("spawn coins")
	var temp = randi_range($reference_nodes/coins.get_child_count()-1, 0)
	var obj = $reference_nodes/coins.get_child(temp).duplicate()
	$moving_nodes/coins.add_child(obj)
	
	await get_tree().create_timer(wait_time*1.9).timeout
	spawn_coins()

func spawn_powers():
	#print("power spawned")
	if stop_game: return
	if stop_spawn:
		await get_tree().create_timer(wait_time).timeout
		spawn_powers()
		return
	if player_rushing: return
	
	var temp = randi_range($reference_nodes/powers.get_child_count()-1, 0)
	var obj = $reference_nodes/powers.get_child(temp).duplicate()
	$moving_nodes/powers.add_child(obj)
	
	await get_tree().create_timer(wait_time*2.2).timeout
	#print("spawn")
	spawn_powers()


func spawn_obstacles():
	if stop_game: return
	if stop_spawn:
		await get_tree().create_timer(wait_time).timeout
		spawn_obstacles()
		return
	#print("obstacle spawned")
	var temp = randi_range($reference_nodes/obstacles.get_child_count()-1, 0)
	var obj = $reference_nodes/obstacles.get_child(temp).duplicate()
	$moving_nodes/obstacles.add_child(obj)
	
	#print(520/speed)
	await get_tree().create_timer(wait_time).timeout
	spawn_obstacles()

var wait_time = 2
var speed = 240
var stop_game = 0

var score = 0
var coins = 0

func score_inc():
	await get_tree().create_timer(0.1).timeout
	if stop_game: return
	
	score += 1
	score_inc()

func coin_add():
	coins += 1

func difficulty():
	#if player_rushing:
		#
		#dif
	#
	await get_tree().create_timer(15).timeout
	print("diff increased")
	speed += 20
	wait_time -= 0.2
	
	difficulty()
	

func _process(delta: float) -> void:
	#$moving_nodes.position.x -= 1
	if stop_game: return
	
	$CanvasLayer/score.text = "Score: " + str(score)
	$CanvasLayer/coins.text = "Coins: " + str(coins/2)
	
	#print(score)
	#score += delta
	#print(score)
	for i in $moving_nodes/obstacles.get_children():
		i.position.x -= speed * delta
	for i in $moving_nodes/powers.get_children():
		i.position.x -= speed * delta
	for i in $moving_nodes/coins.get_children():
		i.position.x -= speed * delta
		#print($moving_nodes/obstacles.get_children())
	

func _on_obstacle_body_entered(body: Node2D) -> void:
	if body == $player:
		if player_shield: 
			print("safed")
			player_shield = 0
			$CanvasLayer/shield.text = "Shield: " + str(0)
			return
		if player_rushing:
			return
		
		return
		$CanvasLayer/red.visible = 1
		stop_game = 1
		$player.move = 0
		$CanvasLayer/restart.visible = 1
		print("dead")

var player_shield = 0
var player_rushing = 0
var stop_spawn = 0

func _on_sheild_taken(body: Node2D) -> void:
	if body == $player:
		player_shield = 1
		$CanvasLayer/shield.text = "Shield: " + str(1) 
func _on_rush_taken(body: Node2D) -> void:
	if body == $player:
		print("rush")
		player_rushing = 1
		def_speed = speed
		def_wait_time = wait_time
		
		speed = 1000
		wait_time= 0.5
		$player.run = 1
		$CanvasLayer/rush.text = "Rush: " + str(1) 
		await get_tree().create_timer(5.0).timeout
		stop_spawn = 1
		await get_tree().create_timer(1.0).timeout
		$player.run = 0
		$CanvasLayer/rush.text = "Rush: " + str(0)
		stop_spawn = 0
		speed  = def_speed
		wait_time  = def_wait_time
		player_rushing = 0
		
func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

#func _on_coin_collected(body: Node2D) -> void:
	#$reference_nodes/coin.visible = 0
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)

extends Node2D

const TILE = 64
const END_X = 7680.0

var block_tex = preload("res://assets/block.png")
var spike_tex = preload("res://assets/spike.png")
var attempts = 1

@onready var player = $Player
@onready var cam = $Camera2D
@onready var status_label = $UI/StatusLabel
@onready var world = $World

func _ready():
	$Player/Trajectory.player = player
	build_level()

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart()
		return
	cam.position.x = player.global_position.x + 220
	if not player.dead and not player.won:
		var pct = clamp(int((player.global_position.x / END_X) * 100.0), 0, 100)
		status_label.text = "Attempt: %d | %d%%" % [attempts, pct]

func build_level():
	for c in world.get_children():
		c.queue_free()
	for x in range(-2, 130):
		add_block(x, 9)
		add_block(x, 10)
	var blocks = [
		 [16, 8], [17, 8],
 [23, 7], [24, 7],
 [30, 6],
 [44, 7], [48, 6], [52, 5], [53, 5], [54, 5],
 [65, 8], [66, 8], [67, 8], [68, 8],
 [76, 7], [81, 6], [82, 6], [87, 7], [88, 7],
 [100, 7], [101, 7], [105, 6], [106, 6], [110, 8], [111, 8]
	]
	for b in blocks:
		add_block(b[0], b[1])
	var spikes = [
 [11, 8],
 [20, 8],
 [27, 8], [28, 8],
 [36, 8],
 [43, 8], [46, 8], [47, 8], [50, 8], [51, 8],
 [66, 7],
 [73, 8], [78, 8], [79, 8], [84, 8], [85, 8],
 [93, 8], [98, 8], [99, 8], [103, 8], [104, 8], [108, 8], [109, 8],
 [116, 8]
	]
	for s in spikes:
		add_spike(s[0], s[1])
	var fin = Area2D.new()
	fin.add_to_group("finish")
	fin.position = Vector2(END_X, 400)
	var cs = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	r.size = Vector2(40, 500)
	cs.shape = r
	fin.add_child(cs)
	world.add_child(fin)

func add_block(gx, gy):
	var b = StaticBody2D.new()
	b.position = Vector2(gx * TILE + 32, gy * TILE + 32)
	var cs = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	r.size = Vector2(64, 64)
	cs.shape = r
	var sp = Sprite2D.new()
	sp.texture = block_tex
	b.add_child(cs)
	b.add_child(sp)
	world.add_child(b)

func add_spike(gx, gy):
	var a = Area2D.new()
	a.add_to_group("spike")
	a.position = Vector2(gx * TILE + 32, gy * TILE + 32)
	var cs = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	r.size = Vector2(28, 34)
	cs.shape = r
	cs.position = Vector2(0, 8)
	var sp = Sprite2D.new()
	sp.texture = spike_tex
	a.add_child(cs)
	a.add_child(sp)
	world.add_child(a)

func on_player_died():
	status_label.text = "Dead! Press R"
	await get_tree().create_timer(0.5).timeout
	restart()

func on_player_won():
	status_label.text = "You Win! Press R to play again"

func restart():
	attempts += 1
	player.global_position = Vector2(128, 520)
	player.velocity = Vector2.ZERO
	player.dead = false
	player.won = false
	player.sprite.rotation = 0

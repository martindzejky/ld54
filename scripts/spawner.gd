extends Node2D
class_name Spawner


@export var customer: PackedScene
var isSpawning := true


func _ready():
    startTimer()

func startTimer():
    await get_tree().create_timer(randf_range(20, 40)).timeout
    spawn()

func spawn():
    if not isSpawning: return
    
    call_deferred('startTimer')
    
    var customerObj = customer.instantiate()
    var level = get_tree().get_first_node_in_group('level')
    
    assert(level, 'Missing level node')
    
    level.add_child(customerObj)
    customerObj.global_position = global_position

extends Node
class_name AIState


@export_node_path() var customerNodePath: NodePath
var customer: Customer

signal transition(to: String)


func _ready():
    customer = get_node(customerNodePath)
    assert(customer, 'Missing customer node!')


# called when the state becomes active
func enter():
    pass

# called when the state is about to stop being active
func exit():
    pass

# called in _process when active
func update(_delta: float):
    pass

# called in _physics_process when active
func physicsUpdate(_delta: float):
    pass

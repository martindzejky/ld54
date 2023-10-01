extends AIState
class_name AIStateGoToCashPay


var cashDeskComputer: Node


func enter():
    
    cashDeskComputer = get_tree().get_first_node_in_group('cash-desk-computer')
    assert(cashDeskComputer, 'Missing cash desk computer!')
    
    customer.targetPosition = cashDeskComputer.global_position
    agent.target_position = cashDeskComputer.global_position
    
    animation.play('walk')
    
func exit():
    
    customer.targetPosition = customer.global_position
    agent.target_position = customer.targetPosition
    agent.velocity = Vector2.ZERO
    
    animation.play('idle')

func physicsUpdate(_delta):
    
    if agent.is_navigation_finished() or agent.distance_to_target() < 20:
        
        print('Paying at the cash desk')
        customer.displayCallout(3)
        
        # TODO: add cash to the shop
        
        emit_signal('transition', 'fetch-paid-products')
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity


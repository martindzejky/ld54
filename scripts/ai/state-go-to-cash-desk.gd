extends AIState
class_name AIStateGoToCashDesk


var cashDeskLeft: ItemContainer


func enter():
    
    cashDeskLeft = get_tree().get_first_node_in_group('cash-desk-left') as ItemContainer
    assert(cashDeskLeft, 'Missing cash desk left side')
    
    customer.targetPosition = cashDeskLeft.global_position
    agent.target_position = cashDeskLeft.global_position
    
    animation.play('walk')
    
func exit():
    
    customer.targetPosition = customer.global_position
    agent.target_position = customer.targetPosition
    agent.velocity = Vector2.ZERO
    
    animation.play('idle')

func physicsUpdate(_delta):
    
    if agent.is_navigation_finished() or agent.distance_to_target() < 20:
        
        print('Approached the cash desk left side')
        customer.displayCallout(2)
        
        if cashDeskLeft.canStoreItem():
            var item := customer.dropItem()
            assert(item, 'Customer should be holding an item when approaching the cash desk')
            cashDeskLeft.storeItem(item)
            emit_signal('transition', 'wait-cash-desk')
        else:
            emit_signal('transition', 'cash-desk-wait-line')
            
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity


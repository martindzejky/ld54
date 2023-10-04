extends AIState
class_name AIStateFetchPaidProducts


var cashDeskRight: ItemContainer


func enter():

    cashDeskRight = get_tree().get_first_node_in_group('cash-desk-right') as ItemContainer
    assert(cashDeskRight, 'Missing cash desk right side')

    customer.targetPosition = cashDeskRight.global_position
    agent.target_position = cashDeskRight.global_position

    animation.play('walk')

func exit():

    customer.targetPosition = customer.global_position
    agent.target_position = customer.targetPosition
    agent.velocity = Vector2.ZERO

func physicsUpdate(_delta):

    if agent.is_navigation_finished() or agent.distance_to_target() < 20:

        print('Approached the cash desk right side')

        # items that do not belong to the customer will be returned
        var itemsToReturn := []

        while cashDeskRight.hasAnyItems():
            var item := cashDeskRight.retrieveItem(0)
            if item.customer == customer:
                customer.pickItem(item, true)
            else:
                itemsToReturn.append(item)

        for item in itemsToReturn:
            cashDeskRight.storeItem(item)

        emit_signal('transition', 'leave')
        return

    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position

    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity


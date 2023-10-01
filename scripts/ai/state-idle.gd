extends AIState
class_name AIStateIdle


func enter():
    super()
    
    customer.get_node('animation').play('idle')
    
    # wait for a random amount of time
    await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
    
    emit_signal('transition', 'wander')

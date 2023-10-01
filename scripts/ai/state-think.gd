extends AIState
class_name AIStateThink


func enter():
    
    animation.play('thinking')
    
    # wait for a random amount of time
    await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
    
    
    if customer.wantsList.size() > 1 and not customer.myBasket:
        emit_signal('transition', 'choose-basket')
        return
    
    if customer.wantsList.size() > 0:
        emit_signal('transition', 'choose-product')
        return
    
    # TODO: go to the cash desk
    if randf() < 0.7:
        push_warning('No more items in wants list, let us pay!')
        emit_signal('transition', 'leave')
        return
    
    # fallback
    emit_signal('transition', 'idle')

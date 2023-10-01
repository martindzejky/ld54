extends AIState
class_name AIStateCashDeskWaitLine


func enter():
    
    await get_tree().create_timer(randf_range(4, 8)).timeout
    call_deferred('emit_signal', 'transition', 'go-to-cash-desk')

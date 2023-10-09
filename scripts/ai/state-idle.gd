extends AIState
class_name AIStateIdle


func enter():
    super()

    animation.play('idle')

    # wait for a random amount of time
    await get_tree().create_timer(randf_range(2.0, 5.0)).timeout

    if randf() < 0.2:
        emit_signal('transition', 'wander')
    else:
        emit_signal('transition', 'think')


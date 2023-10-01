extends Node
class_name AIStateMachine


func _ready():
    
    for state in $states.get_children():
        state.connect('transition', _on_state_transition)
    for state in $active.get_children():
        state.connect('transition', _on_state_transition)
        state.enter()

func _process(delta):
    for state in $active.get_children():
        state.update(delta)
            
func _physics_process(delta):
    for state in $active.get_children():
        state.physicsUpdate(delta)

func _on_state_transition(to: String):
    
    if $active.has_node(to):
        # do not do anything if the state is already active
        push_warning('Not transitioning to state because it is already active: ', to)
        return
    
    for state in $active.get_children():
        state.exit()
        state.reparent($states)
    
    var newState := $states.get_node(to)
    if not newState:
        push_error('Cannot transition to state because it does not exist: ', to)
    
    newState.reparent($active)
    newState.enter()
